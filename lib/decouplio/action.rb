# frozen_string_literal: true

require 'dry-schema'

module Decouplio
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
        @steps ||= []
        @steps << step
      end

      def rescue_for(*errors_to_handle)
        rescue_for_eval = ''
        errors_to_handle.each do |hash|
          rescue_for_eval += "rescue #{hash[:error]} => error; instance.public_send(:#{hash[:handler]}, error, instance.params);"
        end
        rescue_for_eval.prepend('begin;block.call;')
        rescue_for_eval.concat('end')
        last_step = @steps.last
        if last_step.respond_to?(:rescue_for=)
          last_step.rescue_for = rescue_for_eval
        end
      end

      def wrap(klass:, method:, &block)
        @steps << Decouplio::Wrapper.new(klass: klass, method: method, &block)
      end

      def process_steps
        @steps.each do |step|
          if step.class == Symbol
            if @instance.wrapper
              @instance.parent_instance.public_send(step, @instance.params)
            else
              @instance.public_send(step, @instance.params)
            end
          elsif step.class <= Decouplio::Wrapper
            step.call(@instance)
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
    end
  end
end
