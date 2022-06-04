# frozen_string_literal: true

require_relative 'base_step'
require_relative 'shared/step_resolver'

module Decouplio
  module Steps
    class Step < Decouplio::Steps::BaseStep
      def initialize(name:, on_success_type:, on_failure_type:)
        super()
        @name = name
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        result = instance.send(@name, **instance.ctx)
        resolve(result: result, instance: instance)
      end

      def resolve(result:, instance:)
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
