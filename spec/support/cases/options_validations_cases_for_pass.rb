# frozen_string_literal: true

module OptionsValidationsCasesForPass
  def when_pass_on_succes_is_not_allowed
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_step, on_success: :step_one
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def pass_step(**)
        ctx[:pass_step] = 'pass'
      end
    end
  end

  def when_pass_on_failure_is_not_allowed
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_step, on_failure: :step_one
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def pass_step(**)
        ctx[:pass_step] = 'pass'
      end
    end
  end

  def when_pass_finish_him_is_not_a_boolean
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_step, finish_him: 123
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def pass_step(**)
        ctx[:pass_step] = 'pass'
      end
    end
  end

  def when_pass_finish_him_is_a_boolean
    lambda do |_klass|
      logic do
        step :step_one
        pass :handle_step_one, finish_him: true
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_pass_finish_him_is_some_custom_symbol
    lambda do |_klass|
      logic do
        step :step_one
        pass :handle_step_one, finish_him: :some_step
      end

      def step_one(**)
        ctx[:result] = string_param
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_pass_finish_him_is_on_success_symbol
    lambda do |_klass|
      logic do
        step :step_one
        pass :handle_step_one, finish_him: :on_success
      end

      def step_one(**)
        ctx[:result] = 'Success'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_pass_finish_him_is_on_failure_symbol
    lambda do |_klass|
      logic do
        step :step_one
        pass :handle_step_one, finish_him: :on_failure
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_pass_not_allowed_option_provided
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_step, not_allowed_option: :some_option
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def pass_step(**)
        ctx[:pass_step] = 'pass'
      end
    end
  end

  def when_pass_if_and_unless_is_present
    lambda do |_klass|
      logic do
        pass :step_one, if: :some_condition?, unless: :some_condition?
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

  def when_pass_finish_him_if_and_unless_is_present
    lambda do |_klass|
      logic do
        pass :step_one, finish_him: :on_success, if: :some_condition?, unless: :some_condition?
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
end
