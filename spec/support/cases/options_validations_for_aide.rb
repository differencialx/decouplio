# frozen_string_literal: true

class SomeAide
  def self.call(ctx:, value:, **)
    ctx[:result] = value
  end
end

module OptionsValidationsForAide
  def when_aide_finish_him_is_not_a_boolean
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', finish_him: 123
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_aide_finish_him_is_a_boolean
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', finish_him: true
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_aide_finish_him_is_some_custom_symbol
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', finish_him: :some_step
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_aide_on_success_and_finish_him_present
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', on_success: :step_two, finish_him: :on_failure
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

  def when_aide_on_failure_and_finish_him_present
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', on_failure: :step_two, finish_him: :on_success
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

  def when_aide_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', if: :some_condition?, unless: :condition?
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
    end
  end

  def when_aide_on_success_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', on_success: :step_two, if: :some_condition?, unless: :some_condition?
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

  def when_aide_on_failure_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', on_failure: :step_two, if: :some_condition?, unless: :some_condition?
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

  def when_aide_finish_him_if_and_unless_is_present
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', finish_him: :on_success, if: :some_condition?, unless: :some_condition?
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

  def when_aide_on_success_step_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', on_success: :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_aide_on_failure_step_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        aide SomeAide, value: 'Result', on_failure: :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end
end
