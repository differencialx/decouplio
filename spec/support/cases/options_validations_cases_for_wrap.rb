# frozen_string_literal: true

module OptionsValidationsCasesForWrap
  def when_wrap_on_success_method_not_defined
    lambda do |_klass|
      logic do
        wrap :wrap_name, on_success: :step_two do
          step :inner_wrap_step
        end

        step :step_one
        step :step_two
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def inner_wrap_step(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def when_wrap_on_falire_method_not_defined
    lambda do |_klass|
      logic do
        wrap :wrap_name, on_failure: :step_two do
          step :inner_wrap_step
        end

        step :step_one
        step :step_two
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def inner_wrap_step(**)
        ctx[:result] = 'Success'
      end
    end
  end

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

  def when_wrap_if_method_is_not_defined
    lambda do |_klass|
      logic do
        wrap :wrap_name, if: :some_undefined_method do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_wrap_unless_method_is_not_defined
    lambda do |_klass|
      logic do
        wrap :wrap_name, unless: :some_undefined_method do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_wrap_klass_method_not_defined
    lambda do |_klass|
      logic do
        wrap :wrap_name, klass: ClassWithWrapperMethod, method: :turonsakteon do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:result] = 'Success'
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
end
