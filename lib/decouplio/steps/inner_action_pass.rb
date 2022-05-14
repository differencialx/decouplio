# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class InnerActionPass < Decouplio::Steps::BaseStep
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
        instance.error_store.merge(outcome.error_store)

        instance.pass_action

        if @on_success_type == Decouplio::Const::Results::FINISH_HIM
          Decouplio::Const::Results::FINISH_HIM
        else
          Decouplio::Const::Results::PASS
        end
      end
    end
  end
end
