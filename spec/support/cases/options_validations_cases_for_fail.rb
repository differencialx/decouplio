# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module OptionsValidationsCasesForFail
  def when_fail_on_succes_is_not_allowed
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, on_success: :step_one
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
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

      def step_one(string_param:, **)
        ctx[:result] = string_param
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

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_pass_if_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_step, if: :some_undefined_method
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
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
        pass :pass_step, unless: :some_undefined_method
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def pass_step(**)
        ctx[:pass_step] = 'pass'
      end
    end
  end

  def when_fail_finish_him_is_not_a_on_success_or_on_failure_symbol
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, finish_him: :some_step
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
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

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_pass_if_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, if: :some_undefined_method
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end

  def when_pass_if_method_is_not_defined
    lambda do |_klass|
      logic do
        step :step_one
        fail :handle_step_one, unless: :some_undefined_method
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def handle_step_one(**)
        add_error(:step_one, 'Error')
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
