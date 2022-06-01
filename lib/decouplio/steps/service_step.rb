# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class ServiceStep < Decouplio::Steps::BaseStep
      def initialize(name:, service:, on_success_type:, on_failure_type:)
        super()
        @name = name
        @service = service
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        result = @service.call(ctx: instance.ctx)

        resolve(result: result, instance: instance)
      end

      private

      def resolve(result:, instance:)
        if result
          if [
            Decouplio::Const::Results::STEP_PASS,
            Decouplio::Const::Results::PASS,
            Decouplio::Const::Results::FAIL
          ].include?(@on_success_type)
            instance.pass_action
            Decouplio::Const::Results::PASS
          elsif Decouplio::Const::Results::STEP_FAIL == @on_success_type
            instance.fail_action
            Decouplio::Const::Results::PASS
          elsif @on_success_type == Decouplio::Const::Results::FINISH_HIM
            instance.pass_action
            Decouplio::Const::Results::FINISH_HIM
          end
        elsif Decouplio::Const::Results::STEP_PASS == @on_failure_type
          instance.pass_action
          Decouplio::Const::Results::PASS
        elsif Decouplio::Const::Results::STEP_FAIL == @on_failure_type
          instance.fail_action
          Decouplio::Const::Results::PASS
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
