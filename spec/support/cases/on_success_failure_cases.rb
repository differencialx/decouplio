# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module OnSuccessFailureCases
  def on_failure_finish_him
    lambda do |_klass|
      step :step_one
      step :step_two, on_failure: :finis_him
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

  # def on_failure_custom_group
  #   lambda do |_klass|
  #     step :step_one
  #     step :step_two, on_failure: :custom_one_group
  #     step :step_three
  #     group :custom_one do
  #       step :step_four
  #       step :step_five
  #       step :step_six
  #     end

  #     def step_one(param1:, **)
  #       ctx[:result] = param1
  #     end

  #     def step_two(param2:, **)
  #       param2
  #     end

  #     def step_three(**)
  #       ctx[:result] = 'Done'
  #     end

  #     def step_four(**)
  #       ctx[:result] = 1
  #     end

  #     def step_five(**)
  #       ctx[:result] += 1
  #     end

  #     def step_six(**)
  #       ctx[:result] += 1
  #     end
  #   end
  # end

  def on_success_finish_him
    lambda do |_klass|
      step :step_one
      step :step_two, on_success: :finis_him
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

  # def on_success_custom_group
  #   lambda do |_klass|
  #     step :step_one
  #     step :step_two, on_success: :custom_one_group
  #     step :step_three
  #     group :custom_one do
  #       step :step_four
  #       step :step_five
  #       step :step_six
  #     end

  #     def step_one(param1:, **)
  #       ctx[:result] = param1
  #     end

  #     def step_two(param2:, **)
  #       param2
  #     end

  #     def step_three(**)
  #       ctx[:result] = 'Done'
  #     end

  #     def step_four(**)
  #       ctx[:result] = 1
  #     end

  #     def step_five(**)
  #       ctx[:result] += 1
  #     end

  #     def step_six(**)
  #       ctx[:result] += 1
  #     end
  #   end
  # end
end
# rubocop:enable Lint/NestedMethodDefinition
