# frozen_string_literal: true

module OptionsValidationsCasesForFail
  def when_fail_finish_him_is_not_a_boolean
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, finish_him: 123
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_fail_finish_him_is_a_boolean
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, finish_him: true
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_fail_finish_him_is_some_custom_symbol
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, finish_him: :some_step
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_fail_not_allowed_option_provided
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, not_allowed_option: :some_option
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_fail_on_success_and_finish_him_present
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :step_two, finish_him: :on_failure
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_and_finish_him_present
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :step_two, finish_him: :on_success
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_fail_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, if: :some_condition?, unless: :condition?
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

      def condtion?(**)
        true
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_fail_on_success_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :step_two, if: :some_condition?, unless: :some_condition?
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

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :step_two, if: :some_condition?, unless: :some_condition?
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

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_fail_finish_him_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, finish_him: :on_success, if: :some_condition?, unless: :some_condition?
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

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_fail_on_success_step_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_two, on_success: :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_step_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_two, on_failure: :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end
  end
end
