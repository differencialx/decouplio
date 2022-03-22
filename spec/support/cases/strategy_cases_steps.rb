# frozen_string_literal: true

module StrategyCasesSteps
  def strategy_steps
    lambda do |_klass|
      logic do
        step :assign_strategy_one_key
        fail :assign_fail, finish_him: true

        strg :strategy_one, ctx_key: :strategy_one_key do
          on :strg_1, step: :step_one
          on :strg_2, step: :step_two
          on :strg_3, step: :step_three
        end

        step :assign_strategy_two_key

        strg :strategy_two, ctx_key: :strategy_two_key do
          on :strg_4, step: :step_four
          on :strg_5, step: :step_five
        end

        step :final_step
        fail :strategy_failure
      end

      def assign_strategy_one_key(strg_1:, **)
        ctx[:strategy_one_key] = strg_1
      end

      def assign_strategy_two_key(strg_2:, **)
        ctx[:strategy_two_key] = strg_2
      end

      def assign_fail(**)
        ctx[:assign_fail] = 'Assign Fail'
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(param2:, **)
        ctx[:step_two] = param2
      end

      def step_three(param3:, **)
        ctx[:step_three] = param3
      end

      def step_four(param4:, **)
        ctx[:step_four] = param4
      end

      def step_five(param5:, **)
        ctx[:step_five] = param5
      end

      def final_step(final:, **)
        ctx[:result] = final
      end

      def strategy_failure(**)
        ctx[:strategy_failure_handled] = true
      end
    end
  end
end
