# frozen_string_literal: true

module OctoCasesPalps
  def octo_palps
    lambda do |_klass|
      logic do
        step :assign_strategy_one_key
        fail :assign_fail

        octo :strategy_one, ctx_key: :octo_key do
          on :octo1 do
            step :step_one
            step :step_three, if: :process_step_three?
            step :step_four
          end
          on :octo2 do
            step :step_two
            step :step_three
          end
          on :octo3 do
            step :step_one
            step :step_four
            step :assign_second_strategy
          end
        end

        octo :strategy_two, ctx_key: :strategy_two_key, if: :process_strategy_two? do
          on :octo4 do
            step :step_five
            fail :step_four, if: :process_step_four?
          end
          on :octo5 do
            step :step_five
            fail :step_six
            step :step_four
          end
        end

        step :final_step
        fail :strategy_failure
      end

      def assign_strategy_one_key
        ctx[:octo_key] = c.strategy_one_key
      end

      def assign_fail
        ctx[:assign_fail] = 'Assign Fail'
      end

      def step_one
        ctx[:step_one] = c.param1
      end

      def step_two
        ctx[:step_two] = c.param2
      end

      def step_three
        ctx[:step_three] = c.param3
      end

      def step_four
        ctx[:step_four] = ctx[:step_four].to_s + c.param4 unless c.param4.nil?
      end

      def step_five
        ctx[:step_five] = c.param5
      end

      def step_six
        ctx[:step_six] = c.param6
      end

      def final_step
        ctx[:result] = c.final
      end

      def assign_second_strategy
        ctx[:strategy_two_key] = c.strategy_two_key == 'not_existing_strategy' ? nil : c.strategy_two_key
      end

      def process_strategy_two?
        c.process_strategy_two
      end

      def strategy_failure
        ctx[:strategy_failure_handled] = true
      end

      def process_step_three?
        c.process_step_three
      end

      def process_step_four?
        c.process_step_four
      end
    end
  end

  def when_octo_block_is_not_defined
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :some_key
      end
    end
  end

  def when_octo_block_is_empty
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :some_key do
        end
      end
    end
  end
end
