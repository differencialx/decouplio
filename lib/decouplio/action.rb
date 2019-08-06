require 'dry-schema'

module Decouplio
  class Action
    attr_reader :params, :errors, :ctx

    def initialize(ctx: {}, **params)
      @params = params
      @errors = {}
      @ctx = ctx
    end

    def [](key)
      self.ctx[key]
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
        @instance = self.new(params)
        process_validations
        return @instance unless @instance.success?

        process_steps
        @instance
      end

      private

      def process_validations
        validation_result = @schema.call(@instance.params)
        @instance.errors.merge!(validation_result.errors.to_h) && return if validation_result.failure?
        @validations.each do |validation|
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

      def wrap(klass:, method:, &block)
        @steps << Decouplio::Wrapper.new(klass: klass, method: method, &block)
      end

      def process_steps
        @steps.each do |step|
          case step
          when Symbol then @instance.public_send(step, @instance.params)
          when Decouplio::Action then step.call(@instance.params)
          when Decouplio::Wrapper then step.call(@instance.params)
          when Decouplio::Iterator then step.call(@instance.params)
          else
            raise 'FUCK'
          end
        end
      end
    end
  end
end
