# frozen_string_literal: true

module StrategyCasesSquads
  def strategy_squads
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
          step :step_three, if: :process_step_three?
          step :step_four
        end

        squad :squad_two do
          step :step_two
          step :step_three
        end

        squad :squad_four do
          step :step_five
          fail :step_four, if: :process_step_four?
        end

        step :assign_strategy_one_key
        fail :assign_fail

        strg :strategy_one, ctx_key: :strg_key do
          on :strg_1, squad: :squad_one
          on :strg_2, squad: :squad_two
          on :strg_3, squad: :squad_three
        end

        squad :squad_five do
          step :step_five
          fail :step_six
          step :step_four
        end

        strg :strategy_two, ctx_key: :strategy_two_key, if: :process_strategy_two? do
          on :strg_4, squad: :squad_four
          on :strg_5, squad: :squad_five
        end

        step :final_step
        fail :strategy_failure

        squad :squad_three do
          step :step_one
          step :step_four
          step :assign_second_strategy
        end
      end

      def assign_strategy_one_key(strategy_one_key:, **)
        ctx[:strg_key] = strategy_one_key
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
        if !param4.nil?
          ctx[:step_four] = ctx[:step_four].to_s + param4
        end
      end

      def step_five(param5:, **)
        ctx[:step_five] = param5
      end

      def step_six(param6:, **)
        ctx[:step_six] = param6
      end

      def final_step(final:, **)
        ctx[:result] = final
      end

      def assign_second_strategy(strategy_two_key:, **)
        if strategy_two_key == 'not_existing_strategy'
          ctx[:strategy_two_key] = nil
        else
          ctx[:strategy_two_key] = strategy_two_key
        end
      end

      def process_strategy_two?(process_strategy_two:, **)
        process_strategy_two
      end

      def strategy_failure(**)
        ctx[:strategy_failure_handled] = true
      end

      def process_step_three?(process_step_three:, **)
        process_step_three
      end

      def process_step_four?(process_step_four:, **)
        process_step_four
      end
    end
  end
end
