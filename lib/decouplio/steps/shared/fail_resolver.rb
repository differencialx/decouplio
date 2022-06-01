# frozen_string_literal: true

module Decouplio
  module Steps
    module Shared
      class FailResolver
        def self.call(instance:, result:, on_success_type:, on_failure_type:)
          if result
            case on_success_type
            when Decouplio::Const::Results::STEP_PASS, Decouplio::Const::Results::PASS
              instance.pass_action
              Decouplio::Const::Results::PASS
            when Decouplio::Const::Results::STEP_FAIL, Decouplio::Const::Results::FAIL
              instance.fail_action
              Decouplio::Const::Results::PASS
            when Decouplio::Const::Results::FINISH_HIM
              instance.fail_action
              Decouplio::Const::Results::FINISH_HIM
            end
          elsif [
            Decouplio::Const::Results::STEP_PASS,
            Decouplio::Const::Results::PASS
          ].include?(on_failure_type)
            instance.pass_action
            Decouplio::Const::Results::FAIL
          elsif [
            Decouplio::Const::Results::STEP_FAIL,
            Decouplio::Const::Results::FAIL
          ].include?(on_failure_type)
            instance.fail_action
            Decouplio::Const::Results::FAIL
          elsif on_failure_type == Decouplio::Const::Results::FINISH_HIM
            instance.fail_action
            Decouplio::Const::Results::FINISH_HIM
          end
        end
      end
    end
  end
end
