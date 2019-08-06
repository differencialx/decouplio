require 'dry-schema'

module Decouplio
  class Action
    attr_reader :params, :errors

    def initialize(**params)
      @params = params
      @errors = {}
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
        @params = params
        @instance = self.new
        process_validations
        return @instance unless @instance.success?

        process_steps
      end

      private

      def process_validations
        validation_result = @schema.call(@params)
        @instance.errors.merge!(validation_result.errors.to_h) && return if validation_result.failure?
        @validations.each do |validation|
          @instance.public_send(validation, @params)
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
          when Symbol then @instance.public_send(step, @params)
          when Decouplio::Action then step.call(@params)
          when Decouplio::Wrapper then step.call(@params)
          when Decouplio::Iterator then step.call(@params)
          else
            raise 'FUCK'
          end
        end
      end
    end
  end
end
