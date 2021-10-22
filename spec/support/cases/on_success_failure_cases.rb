# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module OnSuccessFailureCases
  def on_failure_finish_him
    lambda do |_klass|
      step :step_one
      step :step_two, on_failure: :finish_him
      step :step_three

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end
    end
  end

  def on_failure_custom_step
    lambda do |_klass|
      step :step_one
      step :step_two, on_failure: :custom_step
      step :step_three
      step :custom_step
      pass :custom_pass_step
      fail :custom_fail_step

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end

      def custom_step(custom_param:, **)
        custom_param
      end

      def custom_pass_step(**)
        ctx[:result] = 'Custom pass step'
      end

      def custom_fail_step(**)
        ctx[:result] = 'Custom fail step'
      end
    end
  end

  def on_success_finish_him
    lambda do |_klass|
      step :step_one
      step :step_two, on_success: :finish_him
      step :step_three

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end
    end
  end

  def on_success_custom_step
    lambda do |_klass|
      step :step_one
      step :step_two, on_success: :custom_step
      step :step_three
      step :custom_step
      pass :custom_pass_step
      fail :custom_fail_step

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end

      def custom_step(custom_param:, **)
        custom_param
      end

      def custom_pass_step(**)
        ctx[:result] = 'Custom pass step'
      end

      def custom_fail_step(**)
        ctx[:result] = 'Custom fail step'
      end
    end
  end

  def on_success_failure_custom_squad
    lambda do |_klass|
      step :step_one
      step :step_two, on_success: { squad: :squad_one, strict: true }, on_failure: :step_three
      step :step_three, on_success: :step_four, on_failure: { squad: :squad_two }
      step :step_four, on_success: { squad: :squad_three, strict: true }, on_failure: :step_five
      step :step_five
      step :step_six, squad: :squad_one
      step :step_seven, squad: %i[squad_one squad_two squad_three]
      step :step_eight, squad: %i[squad_two]
      step :step_nine, squad: %i[squad_one squad_three]
      step :final_step

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(param3:, **)
        param3
      end

      def step_four(param4:, **)
        param4
      end

      def step_five(param5:, **)
        ctx[:step_five] = param5
      end

      def step_six(param6:, **)
        ctx[:step_six] = param6
      end

      def step_seven(param7:, **)
        ctx[:step_seven] = param7
      end

      def step_eight(param8:, **)
        ctx[:step_eight] = param8
      end

      def step_nine(param9:, **)
        ctx[:step_nine] = param9
      end

      def final_step(**)
        ctx[:result] = 'Final'
      end
    end
  end

  def on_success_failure_custom_group_with_block
    lambda do |_klass|
      step :step_one
      step :step_two, on_success: :squad_one!, on_failure: :step_three
      step :step_three, on_success: :squad_three!, on_failure: :final_step
      step :step_four, squad: :squad_one
      step :step_five, squad: %i[squad_one squad_two squad_three]
      step :step_six, squad: %i[squad_two]
      step :step_seven, squad: %i[squad_one squad_three]
      step :final_step

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(param3:, **)
        param3
      end

      def step_four(param4:, **)
        ctx[:result] = 'Four'
      end

      def step_five(param5:, **)
        ctx[:result] = 'Five'
      end

      def step_six(param6:, **)
        ctx[:result] = 'Six'
      end

      def step_seven(param7:, **)
        ctx[:result] = 'Seven'
      end

      def final_step(**)
        ctx[:result] = 'Final'
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
