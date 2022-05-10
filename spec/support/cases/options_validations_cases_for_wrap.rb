# frozen_string_literal: true

module OptionsValidationsCasesForWrap
  def when_wrap_on_success_step_not_defined
    lambda do |_klass|
      logic do
        wrap :wrap_name, on_success: :step_two do
          step :inner_wrap_step
        end

        step :step_one
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def inner_wrap_step(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def when_wrap_on_failure_step_not_defined
    lambda do |_klass|
      logic do
        wrap :wrap_name, on_failure: :step_two do
          step :inner_wrap_step
        end

        step :step_one
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def inner_wrap_step(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def when_wrap_finish_him_is_not_a_boolean
    lambda do |_klass|
      logic do
        wrap :wrap_name, finish_him: 123 do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_wrap_finish_him_is_a_boolean
    lambda do |_klass|
      logic do
        wrap :wrap_name, finish_him: true do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_wrap_finish_him_is_not_a_on_success_or_on_failure_symbol
    lambda do |_klass|
      logic do
        wrap :wrap_name, finish_him: :some_option do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_wrap_not_allowed_option_provided
    lambda do |_klass|
      logic do
        wrap :wrap_name, not_allowed_option: :some_option do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_wrap_klass_is_present_and_method_was_not_passed
    lambda do |_klass|
      logic do
        wrap :wrap_name, klass: ClassWithWrapperMethod do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def when_wrap_method_is_present_and_klass_was_not_passed
    lambda do |_klass|
      logic do
        wrap :wrap_name, method: :turonsakteon do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def when_wrap_name_is_not_specified
    lambda do |_klass|
      logic do
        wrap klass: ClassWithWrapperMethod, method: :some_method do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def when_wrap_on_success_and_finish_him_present
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_success: :step_two, finish_him: :on_failure do
          step :step_one
        end
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

  def when_wrap_on_failure_and_finish_him_present
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_failure: :step_two, finish_him: :on_success do
          step :step_one
        end
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

  def when_wrap_if_and_unless_is_present
    lambda do |_klass|
      logic do
        wrap :some_wrap, if: :some_condition?, unless: :condition? do
          step :step_one
        end
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

  def when_wrap_on_success_if_and_unless_is_present
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_success: :step_two, if: :some_condition?, unless: :some_condition? do
          step :step_one
        end
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

  def when_wrap_on_failure_if_and_unless_is_present
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_failure: :step_two, if: :some_condition?, unless: :some_condition? do
          step :step_one
        end
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

  def when_wrap_finish_him_if_and_unless_is_present
    lambda do |_klass|
      logic do
        wrap :some_wrap, finish_him: :on_success, if: :some_condition?, unless: :some_condition? do
          step :step_one
        end
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

  def when_wrap_on_success_step_is_not_defined
    lambda do |_klass|
      logic do
        step :step_three
        wrap :some_wrap, on_success: :step_three do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_three(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_wrap_on_failure_step_is_not_defined
    lambda do |_klass|
      logic do
        step :step_threee
        wrap :some_wrap, on_failure: :step_three do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_three(**)
        ctx[:step_two] = 'Success'
      end
    end
  end
end
