# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class InnerActionFail < Decouplio::Steps::BaseStep
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

        instance.errors.merge!(outcome.errors)

        if result
          case @on_success_type
          when Decouplio::Const::Results::PASS
            instance.pass_action
            Decouplio::Const::Results::PASS
          when Decouplio::Const::Results::FAIL
            instance.fail_action
            Decouplio::Const::Results::PASS
          when Decouplio::Const::Results::FINISH_HIM
            instance.fail_action
            Decouplio::Const::Results::FINISH_HIM
          end
        elsif @on_failure_type == Decouplio::Const::Results::PASS
          instance.pass_action
          Decouplio::Const::Results::FAIL
        elsif @on_failure_type == Decouplio::Const::Results::FAIL
          instance.fail_action
          Decouplio::Const::Results::FAIL
        elsif @on_failure_type == Decouplio::Const::Results::FINISH_HIM
          instance.fail_action
          Decouplio::Const::Results::FINISH_HIM
        end
      end
    end
  end
end