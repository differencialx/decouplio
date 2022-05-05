# frozen_string_literal: true

module OctoCasesPalps
  def octo_palps
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
          step :step_three, if: :process_step_three?
          step :step_four
        end

        palp :palp_two do
          step :step_two
          step :step_three
        end

        palp :palp_three do
          step :step_one
          step :step_four
          step :assign_second_strategy
        end

        palp :palp_four do
          step :step_five
          fail :step_four, if: :process_step_four?
        end

        palp :palp_five do
          step :step_five
          fail :step_six
          step :step_four
        end

        step :assign_strategy_one_key
        fail :assign_fail

        octo :strategy_one, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
          on :octo2, palp: :palp_two
          on :octo3, palp: :palp_three
        end

        octo :strategy_two, ctx_key: :strategy_two_key, if: :process_strategy_two? do
          on :octo4, palp: :palp_four
          on :octo5, palp: :palp_five
        end

        step :final_step
        fail :strategy_failure
      end

      def assign_strategy_one_key(strategy_one_key:, **)
        ctx[:octo_key] = strategy_one_key
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
        ctx[:step_four] = ctx[:step_four].to_s + param4 unless param4.nil?
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
        ctx[:strategy_two_key] = strategy_two_key == 'not_existing_strategy' ? nil : strategy_two_key
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

  def when_octo_palps_inner_on_success_on_failure
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step, on_success: :pass_one
          fail :palp_fail, on_success: :palp_pass
          resq error_handler_palp_fail: ArgumentError
          pass :palp_pass
        end

        palp :palp_two do
          pass :palp_pass
          step :palp_step, on_failure: :pass_one
          resq error_handler_palp_step: ArgumentError
          fail :palp_fail, on_failure: :step_two
        end

        palp :palp_three do
          pass :palp_pass
          resq error_handler_palp_pass: ArgumentError
          step :palp_step, on_success: :palp_fail, on_failure: :step_two
          fail :palp_fail, on_success: :pass_one, on_failure: :palp_step
          step :palp_step
        end

        step :step_one
        fail :fail_one, on_failure: :pass_one

        octo :octo_name, ctx_key: :octo_key do
          on :octo_key1, palp: :palp_one
          on :octo_key2, palp: :palp_two
          on :octo_key3, palp: :palp_three
        end

        step :step_two
        pass :pass_one
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end

      def fail_one(param2:, **)
        ctx[:fail_one] = param2.call
      end

      def palp_step(param3:, **)
        ctx[:palp_step] = param3.call
      end

      def palp_fail(param4:, **)
        ctx[:palp_fail] = param4.call
      end

      def palp_pass(param5:, **)
        ctx[:palp_pass] = param5.call
      end

      def step_two(param6:, **)
        ctx[:step_two] = param6.call
      end

      def pass_one(param7:, **)
        ctx[:pass_one] = param7.call
      end

      def fail_two(param8:, **)
        ctx[:fail_two] = param8.call
      end

      def error_handler_palp_step(error, **)
        ctx[:error_handler_palp_step] = error.message
      end

      def error_handler_palp_fail(error, **)
        ctx[:error_handler_palp_fail] = error.message
      end

      def error_handler_palp_pass(error, **)
        ctx[:error_handler_palp_pass] = error.message
      end
    end
  end
end
