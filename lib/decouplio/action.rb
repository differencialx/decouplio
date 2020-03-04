# frozen_string_literal: true

require 'dry-schema'
require_relative 'errors/no_step_error'
require_relative 'errors/undefined_handler_method_error'

# rubocop:disable Metrics/ClassLength
module Decouplio
  class Action
    attr_reader :errors, :ctx, :wrapper, :parent_instance

    def initialize(parent_instance: nil, wrapper: false, **params)
      @params = params
      @errors = {}
      @parent_instance = parent_instance
      @ctx = @parent_instance&.ctx || {}
      @wrapper = wrapper
      @tags = {}
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
    end

    def add_tag(tag, value)
      @tags[tag] = value
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
        raise Errors::NoStepError, 'Step or wrapper or iterator or validations should be provided' unless @steps || @schema || @validations

        @instance = new(params)
        process_validations
        return @instance unless @instance.success?

        process_steps

        block_given? ? block.call(@instance) : @instance
      end

      private

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

      def gendalf(klass, method_name, *args)
        init_steps

        @steps[Decouplio::Gendalf.new(klass)] = args_to_options(args).merge(method_name: method_name)
      end

      def step(step, *args)
        init_steps
        @steps[step] = args_to_options(args)
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
        step = Decouplio::Wrapper.new(klass: klass, method: method, &block)
        @steps[step] = options
      end

      def process_steps
        step_keys.each do |step|
          if step.is_a?(Symbol)
            process_method(step)
          elsif step.is_a?(Decouplio::Gendalf)
            user_key = @steps[step].fetch(:user_key) { :user }
            model_key = @steps[step].fetch(:model_key) { :model }
            method_name = @steps[step].fetch(:method_name)
            has_access = step.klass.new(@instance.params[user_key], @instance.ctx[model_key]).public_send(method_name)

            unless has_access
              @instance.add_error({ gendalf: ['You shall not pass!', "#{step.klass}##{method_name}"] })
              @instance.add_tag(:gendalf, false)
              break
            end
            @instance.add_tag(:gendalf, true)
          elsif step.class <= Decouplio::Wrapper
            process_wrapper(step)
          elsif step <= Decouplio::Iterator
            process_iterator(step)
          elsif step <= Decouplio::Action
            process_action(step, proc { return })
          else
            raise 'FUCK'
          end
          break if @steps.dig(step, :finish_him) && @instance.failure?
        end
      end

      def process_method(step)
        if @instance.wrapper
          @instance.parent_instance.public_send(step, @instance.params)
        else
          check_handler_methods(@rescue_steps.dig(step, :handler_hash)) if @rescue_steps.dig(step, :handler_hash)
          process_symbol_step(step) do
            call_instance_method(step)
          rescue *@rescue_steps[step][:error_classes] => e
            raise e unless @rescue_steps[step][:handler_hash][e.class]

            @instance.public_send(@rescue_steps[step][:handler_hash][e.class], e, **@instance.params)
          end
        end
      end

      def process_wrapper(step)
        process_wrapper_step(step) do
          step.call(@instance)
        rescue *@rescue_steps[step][:error_classes] => e
          @instance.public_send(@rescue_steps[step][:handler_hash][e.class], e, **@instance.params)
        end
      end

      def process_iterator(step)
        step.call(@instance.params)
      end

      def process_action(step, break_method)
        outcome = step.call(@instance.params.merge(parent_instance: @instance))
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

      def process_symbol_step(step, &block)
        if rescue_step?(step)
          block.call
        else
          call_instance_method(step)
        end
      end

      def process_wrapper_step(step, &block)
        if rescue_step?(step)
          block.call
        else
          step.call(@instance)
        end
      end

      def rescue_step?(step)
        @rescue_steps[step]
      end

      def call_instance_method(step)
        return if @steps.dig(step, :on_failure) && @instance.success?

        @instance.public_send(step, @instance.params)
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
