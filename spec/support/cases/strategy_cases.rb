# frozen_string_literal: true

module StrategyCases
  def strategy_squads
    lambda do |_klass|
      logic do
        squad :squad_one do 
          step :step_one
          step :step_three
          step :step_four
        end
        squad :squad_two do
          step :step_two  
          step :step_three
        end
        squad :squad_three do
          step :step_one
          step :step_four
        end
        squad :squad_four do
          step :step_five
          fail :step_four
        end
        squad :squad_five do
          fail :step_six
          step :step_five
          step :four
        end
  
        step :assign_strategy_one_key
  
        strg :strategy_one, ctx_key: :strategy_one_key do
          on :strg_1, squad: :squad_one
          on :strg_2, squad: :squad_two
          on :strg_3, squad: :squad_three
        end
  
        strg :strategy_two, ctx_key: :strategy_two_key, if: :process_strategy_two? do
          on :strg_4, squad: :squad_four
          on :strg_5, squad: :squad_five
        end
    
        step :final_step
        fail :strategy_failure
      end

      def assign_strategy_key(strategy_key:, **)
        ctx[:strg_key] = strategy_key
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
        ctx[:step_five] = param4
      end

      def step_six(param6:, **)
        ctx[:step_six] = param4
      end

      def final_step(**)
        ctx[:result] = 'Final'
      end

      def process_strategy_two?(**)

      end
    end
  end
end

