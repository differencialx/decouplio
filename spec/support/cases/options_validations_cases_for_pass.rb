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

      def step_one(string_param:, **)
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

      def step_one(string_param:, **)
        ctx[:result] = string_param
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

  def when_pass_if_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_step, if: :some_undefined_method
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def pass_step(**)
        ctx[:pass_step] = 'pass'
      end
    end
  end

  def when_pass_unless_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_step, unless: :some_undefined_method
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def pass_step(**)
        ctx[:pass_step] = 'pass'
      end
    end
  end

  def when_pass_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        pass :step_two
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end
end
