require_relative 'base_if_condition'

module Decouplio
  module Steps
    class IfConditionFail < Decouplio::Steps::BaseIfCondition
      private

      def resolve(result:, instance:)
        instance.fail_action
        if result
          Decouplio::Const::PASS
        else
          # In case fail track if condition returns false
          # Then we should fail action as next action
          # can be empty. Consider to optimize it somehow
          # to avoid multiple call of Action#instance.fail_action
          Decouplio::Const::FAIL
        end
      end
    end
  end
end
