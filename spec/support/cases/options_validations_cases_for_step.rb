# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module OptionsValidationsCasesForStep
  def when_step_on_success_step_method_not_defined
    lambda do |_klass|
      logic do
        step :step_one, on_success: :step_two
        step :step_two
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_on_failure_step_method_not_defined
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :step_two
        step :step_two
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_on_success_step_not_defined
    lambda do |_klass|
      logic do
        step :step_one, on_success: :step_two
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_on_failure_step_not_defined
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :step_two
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_finish_him_is_not_a_boolean
    lambda do |_klass|
      logic do
        step :step_one, finish_him: 123
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_finish_him_is_a_boolean
    lambda do |_klass|
      logic do
        step :step_one, finish_him: true
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_finish_him_is_not_a_on_success_or_on_failure_symbol
    lambda do |_klass|
      logic do
        step :step_one, finish_him: :some_step
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_not_allowed_option_provided
    lambda do |_klass|
      logic do
        step :step_one, not_allowed_option: :some_option
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_if_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one, if: :some_undefined_method
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_unless_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one, unless: :some_undefined_method
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_step_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
