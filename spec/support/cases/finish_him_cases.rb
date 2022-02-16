# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module FinishHimCases
  def finish_him_on_success
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, finish_him: :on_success
        step :step_three
      end

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
      logic do
        step :step_one
        step :step_two, finish_him: :on_failure
        step :step_three
      end

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

  def finish_him_true_for_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :step_two, finish_him: true
        step :step_three
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        ctx[:step_two] = param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end
    end
  end

  def finish_him_true_for_pass
    lambda do |_klass|
      logic do
        step :step_one
        pass :step_two, finish_him: true
        step :step_three
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        ctx[:step_two] = param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
