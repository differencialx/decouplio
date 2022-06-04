# frozen_string_literal: true

require_relative 'base_step'
require_relative '../processor'
require_relative 'shared/step_resolver'

module Decouplio
  module Steps
    class Wrap < Decouplio::Steps::BaseStep
      def initialize(name:, klass:, method:, wrap_flow:, on_success_type:, on_failure_type:)
        super()
        @name = name
        @klass = klass
        @method = method
        @wrap_flow = wrap_flow
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        if specific_wrap?
          @klass.public_send(@method) do
            Decouplio::Processor.call(instance: instance, **@wrap_flow)
          end
        else
          Decouplio::Processor.call(instance: instance, **@wrap_flow)
        end

        resolve(instance: instance)
      end

      private

      def specific_wrap?
        @klass && @method
      end

      def resolve(instance:)
        result = instance.success?

        Decouplio::Steps::Shared::StepResolver.call(
          instance: instance,
          result: result,
          on_success_type: @on_success_type,
          on_failure_type: @on_failure_type
        )
      end
    end
  end
end
