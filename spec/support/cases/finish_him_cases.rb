# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module FinishHimCases
  def finish_him_on_success
    lambda do |_klass|
      step :step_one
      step :step_two, finish_him: :on_success
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

  def finish_him_on_failure
    lambda do |_klass|
      step :step_one
      step :step_two, finish_him: :on_failure
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

  def finish_him_anyway
    lambda do |_klass|
      step :step_one
      step :step_two, finish_him: true
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
end
# rubocop:enable Lint/NestedMethodDefinition
