# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module InnerActionCases
  InnerAction = Class.new(Decouplio::Action) do
    # validate :validate_inner_action_param

    # step :multiply

    def multiply(inner_action_param:, **)
      ctx[:result] = inner_action_param * 2
    end

    def validate_inner_action_param(inner_action_param:, **)
      return if inner_action_param == 42

      add_error(invalid_inner_action_param: 'Invalid inner_action_param')
    end
  end

  def inner_action
    lambda do |_klass|
      step InnerAction
      step :step_one

      def step_one(integer_param:, **)
        ctx[:result] = ctx[:result] - integer_param
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
