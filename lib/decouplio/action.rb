# frozen_string_literal: true

require 'dry-schema'
require_relative 'errors/no_step_error'
require_relative 'errors/undefined_handler_method_error'
require_relative 'errors/prepare_params_error'

# rubocop:disable Metrics/ClassLength
module Decouplio
  class Action
    attr_reader :errors, :ctx, :wrapper, :parent_instance
    attr_writer :params

    def initialize(parent_instance: nil, wrapper: false, **params)
      @params = params
      @errors = {}
      @parent_instance = parent_instance
      @ctx = @parent_instance&.ctx || {}
      @wrapper = wrapper
      @tags = {}
      @steps_results = {}
      @last_step_failed = false
    end

    def [](key)
      ctx[key]
    end

    def params
      @params.clone
    end

    def success?
      errors.empty?
    end

    def failure?
      !success?
    end

    def add_error(errors_hash)
      errors_hash.each_pair do |key, val|
        errors_hash[key] = [val].flatten
      end
      errors.merge!(errors_hash)
      @last_step_failed = true
    end

    def add_tag(tag, value)
      @tags[tag] = value
    end

    def reset_last_error_added
      @last_step_failed = false
    end

    def fail_last_step
      @last_step_failed = true
    end

    def last_step_success?
      !@last_step_failed
    end

    def method_missing(method_name, *args, &block)
      name = method_name.to_s[0..-2].to_sym
      if @tags.keys.include?(name)
        @tags[name]
      else
        super
      end
    end

    class << self
      def call(**params, &block)
        raise Errors::NoStepError, 'Step or wrapper or iterator or validations or prepare_params should be provided' unless @prepare_params || @steps || @schema || @validations

        @instance = new(params)
        process_prepare_params
        process_validations
        return @instance unless @instance.success?

        process_steps

        block_given? ? block.call(@instance) : @instance
      end

      private

      def process_prepare_params
        return unless @prepare_params

        stp = @prepare_params[:stp]
        block = @prepare_params[:block]

        raise Errors::PrepareParamsError, 'Method or action class or block should be provided for prepare params' if stp && block

        prepared_params = if stp.is_a?(Symbol)
          @instance.public_send(stp, @instance.params)
        elsif stp && stp <= Decouplio::Action
          stp.call(@instance.params).params
        elsif block
          block.call(@instance.params)
        end

        raise Errors::PrepareParamsError, 'Prepare params should return a Hash' unless prepared_params.is_a?(Hash)

        @instance.params = prepared_params
      end

      def process_validations
        validation_result = @schema&.call(@instance.params)
        @instance.errors.merge!(validation_result.errors.to_h) && return if validation_result&.failure?
        @validations&.each do |validation|
          @instance.public_send(validation, @instance.params)
        end
      end

      def validate_inputs(&block)
        @schema = Dry::Schema.Params(&block)
      end

      def validate(validation)
        @validations ||= []
        @validations << validation
      end

      def prepare_params(stp = nil, &block)
        init_steps

        @prepare_params = { stp: stp, block: block }
      end

      def gendalf(klass, method_name, *args)
        init_steps

        @steps[Decouplio::Gendalf.new(klass)] = args_to_options(args).merge(method_name: method_name)
      end

      def step(stp, *args)
        init_steps
        @steps[stp] = args_to_options(args)
      end

      def rescue_for(**errors_to_handle, &block)
        init_steps
        raise_no_step_error if rescue_for_not_allowed?(&block)
        yield_self(&block) if block_given? # TODO: finish resque block

        @rescue_steps[last_step] = {
          error_classes: errors_to_handle.values.flatten,
          handler_hash: handler_hash(errors_to_handle)
        }
      end

      def init_steps
        @steps ||= {}
        @rescue_steps ||= {}
      end

      def check_handler_methods(handler_hash)
        handler_hash.each_value do |handler_method|
          next if @instance.respond_to?(handler_method)

          raise Errors::UndefinedHandlerMethodError, "Please define #{handler_method} method"
        end
      end

      def wrap(klass: Wrappers::SimpleWrapper, method: :wrap, **options, &block)
        init_steps
        stp = Decouplio::Wrapper.new(klass: klass, method: method, &block)

        @steps[stp] = options
      end

      def process_steps
        break_process_steps = proc { return }
        step_keys.each do |stp|
          if stp.is_a?(Symbol)
            process_method(stp)
          elsif stp.is_a?(Decouplio::Gendalf)
            user_key = @steps[stp].fetch(:user_key) { :user }
            model_key = @steps[stp].fetch(:model_key) { :model }
            method_name = @steps[stp].fetch(:method_name)
            has_access = stp.klass.new(@instance.params[user_key], @instance.ctx[model_key]).public_send(method_name)

            unless has_access
              @instance.add_error({ gendalf: ['You shall not pass!', "#{stp.klass}##{method_name}"] })
              @instance.add_tag(:gendalf, false)
              break
            end
            @instance.add_tag(:gendalf, true)
          elsif stp.class <= Decouplio::Wrapper
            process_wrapper(stp, break_process_steps)
          elsif stp <= Decouplio::Iterator
            process_iterator(stp)
          elsif stp <= Decouplio::Action
            process_action(stp, break_process_steps)
          else
            raise 'FUCK'
          end
          break if @steps.dig(stp, :finish_him) && @instance.failure?
        end
      end

      def process_method(stp)
        if @instance.wrapper
          @instance.parent_instance.public_send(stp, @instance.params)
          process_wrapper_tags_for_steps(stp)
        else
          check_handler_methods(@rescue_steps.dig(stp, :handler_hash)) if @rescue_steps.dig(stp, :handler_hash)
          process_symbol_step(stp) do
            call_instance_method(stp)
          rescue *@rescue_steps[stp][:error_classes] => e
            raise e unless @rescue_steps[stp][:handler_hash][e.class]

            @instance.public_send(@rescue_steps[stp][:handler_hash][e.class], e, **@instance.params)
            process_tags(stp, false)
          end
        end
      rescue => error
        if @instance.wrapper
          process_wrapper_tags_for_steps(stp, false)
        else
          process_tags(stp, false)
        end
        raise error
      end

      def process_wrapper(stp, break_process_steps)
        process_wrapper_step(stp) do
          call_wrapper(stp)
        rescue *@rescue_steps[stp][:error_classes] => e
          @instance.public_send(@rescue_steps[stp][:handler_hash][e.class], e, **@instance.params)
          process_tags(stp, false)
          @steps.dig(stp, :finish_him) ? break_process_steps.call : @instance.fail_last_step
        end
      end

      def process_iterator(stp)
        stp.call(@instance.params)
      end

      def process_action(stp, break_method)
        outcome = stp.call(@instance.params.merge(parent_instance: @instance))
        if outcome.success?
        else
          @instance.errors.merge!(outcome.errors) && break_method.call
        end
      end

      def args_to_options(args)
        options = args.map do |el|
          case el.class.to_s
          when 'Symbol' then { el => true }
          when 'Hash' then el
          end
        end.compact.reduce(&:merge)
        return {} if options.nil?

        validate_options(options)
      end

      def validate_options(options)
        options
      end

      def process_symbol_step(stp, &block)
        if rescue_step?(stp)
          block.call
        else
          call_instance_method(stp)
        end
      end

      def process_wrapper_step(stp, &block)
        if rescue_step?(stp)
          block.call
        else
          call_wrapper(stp)
        end
        return unless @steps.dig(stp, :tag)

        @instance.add_tag(@steps.dig(stp, :tag), @instance.last_step_success?)
      end

      def call_wrapper(stp)
        stp.call(@instance)
      end

      def rescue_step?(stp)
        @rescue_steps[stp]
      end

      def call_instance_method(stp)
        return if @steps.dig(stp, :on_failure) && @instance.success?

        @instance.public_send(stp, @instance.params)

        process_tags(stp)
      end

      def process_tags(stp, result = @instance.last_step_success?)
        return unless @steps.dig(stp, :tag)

        @instance.add_tag(@steps.dig(stp, :tag), result)
        @instance.reset_last_error_added
      end

      def process_wrapper_tags_for_steps(stp, result = @instance.last_step_success?)
        return unless @steps.dig(stp, :tag)

        @instance.parent_instance.add_tag(@steps.dig(stp, :tag), result)
        @instance.reset_last_error_added
      end

      def handler_hash(errors_to_handle)
        hash_case = {}

        errors_to_handle.each do |handler_method, error_classes|
          [error_classes].flatten.each do |error_class|
            hash_case[error_class] = handler_method
          end
        end
        hash_case
      end

      def step_keys
        @steps.keys
      end

      def rescue_for_not_allowed?(&block)
        return false if block_given? && last_step.nil?

        return true if last_step.nil?

        false
      end

      def last_step
        step_keys.last
      end

      def raise_no_step_error
        raise Errors::NoStepError, 'rescue_for should be defined after step or wrapper or iterator or with block'
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
