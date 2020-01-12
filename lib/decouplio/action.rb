# frozen_string_literal: true

require 'dry-schema'

module Decouplio
  class NoStepError < StandardError; end
  class UndefinedHandlerMethod < StandardError; end
  class Action
    attr_reader :errors, :ctx, :wrapper, :parent_instance

    def initialize(parent_instance: nil, wrapper: false, **params)
      @params = params
      @errors = {}
      @parent_instance = parent_instance
      @ctx = @parent_instance&.ctx || {}
      @wrapper = wrapper
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

    def add_error(key, message)
      errors.store(key, [message].flatten)
    end

    class << self
      def call(**params)
        @instance = new(params)
        process_validations
        return @instance unless @instance.success?

        process_steps
        @instance
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

      def step(step)
        init_steps
        @steps << step
      end

      def rescue_for(**errors_to_handle)
        init_steps
        last_step = @steps.last
        raise NoStepError, 'rescue_for should be defined after step or wrapper or iterator' unless last_step

        @rescue_steps[last_step] = {
          error_classes: errors_to_handle.values.flatten,
          handler_hash: handler_hash(errors_to_handle)
        }
      end

      def init_steps
        @steps ||= []
        @rescue_steps ||= {}
      end

      def check_handler_methods(handler_hash)
        handler_hash.each_value do |handler_method|
          raise UndefinedHandlerMethod, "Please define #{handler_method} method" unless @instance.respond_to?(handler_method)
        end
      end

      def wrap(klass:, method:, &block)
        @steps << Decouplio::Wrapper.new(klass: klass, method: method, &block)
      end

      def process_steps
        @steps.each do |step|
          if step.is_a?(Symbol)
            if @instance.wrapper
              @instance.parent_instance.public_send(step, @instance.params)
            else
              check_handler_methods(@rescue_steps.dig(step, :handler_hash)) if @rescue_steps.dig(step, :handler_hash)
              process_symbol_step(step) do
                call_instance_method(step)
              rescue *@rescue_steps[step][:error_classes] => error
                @instance.public_send(@rescue_steps[step][:handler_hash][error.class], error, **@instance.params)
              end
            end
          elsif step.class <= Decouplio::Wrapper
            process_wrapper_step(step) do
              step.call(@instance)
            rescue *@rescue_steps[step][:error_classes] => error
              @instance.public_send(@rescue_steps[step][:handler_hash][error.class], error, **@instance.params)
            end
          elsif step <= Decouplio::Iterator
            step.call(@instance.params)
          elsif step <= Decouplio::Action
            outcome = step.call(@instance.params.merge(parent_instance: @instance))
            @instance.errors.merge!(outcome.errors) && break if outcome.failure?
          else
            raise 'FUCK'
          end
        end
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
    end
  end
end
