require_relative 'base_unless_condition'

module Decouplio
  module Steps
    class UnlessConditionFail < Decouplio::Steps::BaseUnlessCondition
      def resolve(result:, instance:)
        instance.fail_action
        if result
          # In case fail track unless condition returns true
          # Then we should fail action as next action
          # can be empty. Consider to optimize it somehow
          # to avoid multiple call of Action#instance.fail_action
          Decouplio::Const::FAIL
        else
          Decouplio::Const::PASS
        end
      end
    end
  end
end
