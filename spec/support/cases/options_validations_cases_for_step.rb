# frozen_string_literal: true

module OptionsValidationsCasesForStep
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

  def when_step_on_success_and_finish_him_present
    lambda do |_klass|
      logic do
        step :step_one, on_success: :step_two, finish_him: :on_failure
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_step_on_failure_and_finish_him_present
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :step_two, finish_him: :on_success
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_step_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one, if: :some_condition?, unless: :condition?
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def some_condition?(**)
        false
      end

      def condition?(**)
        true
      end
    end
  end

  def when_step_on_success_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one, on_success: :step_two, if: :some_condition?, unless: :some_condition?
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def some_condition?(**)
        false
      end
    end
  end

  def when_step_on_failure_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :step_two, if: :some_condition?, unless: :some_condition?
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def some_condition?(**)
        false
      end
    end
  end

  def when_step_finish_him_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one, finish_him: :on_success, if: :some_condition?, unless: :some_condition?
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def some_condition?(**)
        false
      end
    end
  end

  def when_step_on_success_step_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_success: :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_step_on_failure_step_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_failure: :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_step_on_error_step_is_not_defined
    # TODO: implement
  end
end
