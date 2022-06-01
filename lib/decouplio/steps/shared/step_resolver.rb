# frozen_string_literal: true

module Decouplio
  module Steps
    module Shared
      class StepResolver
        def self.call(instance:, result:, on_success_type:, on_failure_type:)
          if result
            if [
              Decouplio::Const::Results::PASS,
              Decouplio::Const::Results::FAIL,
              Decouplio::Const::Results::STEP_PASS
            ].include?(on_success_type)
              instance.pass_action
              Decouplio::Const::Results::PASS
            elsif Decouplio::Const::Results::STEP_FAIL == on_success_type
              instance.fail_action
              Decouplio::Const::Results::PASS
            elsif on_success_type == Decouplio::Const::Results::FINISH_HIM
              instance.pass_action
              Decouplio::Const::Results::FINISH_HIM
            end
          elsif Decouplio::Const::Results::STEP_PASS == on_failure_type
            instance.pass_action
            Decouplio::Const::Results::PASS
          elsif Decouplio::Const::Results::STEP_FAIL == on_failure_type
            instance.fail_action
            Decouplio::Const::Results::PASS
          elsif on_failure_type == Decouplio::Const::Results::PASS
            instance.pass_action
            Decouplio::Const::Results::FAIL
          elsif on_failure_type == Decouplio::Const::Results::FAIL
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
