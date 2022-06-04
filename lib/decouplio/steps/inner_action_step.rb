# frozen_string_literal: true

require_relative 'base_step'
require_relative 'shared/step_resolver'

module Decouplio
  module Steps
    class InnerActionStep < Decouplio::Steps::BaseStep
      def initialize(name:, action:, on_success_type:, on_failure_type:)
        super()
        @name = name
        @action = action
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        outcome = @action.call(parent_ctx: instance.ctx, parent_railway_flow: instance.railway_flow)

        resolve(outcome: outcome, instance: instance)
      end

      private

      def resolve(outcome:, instance:)
        result = outcome.success?

        instance.error_store.merge(outcome.error_store)

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
