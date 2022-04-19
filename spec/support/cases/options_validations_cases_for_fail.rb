# frozen_string_literal: true

module OptionsValidationsCasesForFail
  def when_fail_on_succes_is_not_allowed
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, on_success: :step_one
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_fail_on_failure_is_not_allowed
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, on_failure: :step_one
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

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

  def when_fail_finish_him_is_on_success_symbol
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, finish_him: :on_success
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_fail_finish_him_is_on_failure_symbol
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, finish_him: :on_failure
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

  def when_fail_if_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, if: :some_undefined_method
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_fail_unless_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, unless: :some_undefined_method
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_fail_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        fail :step_two
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end
end
