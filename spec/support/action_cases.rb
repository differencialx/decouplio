# frozen_string_literal: true

module ActionCases
  def steps
    lambda do |_klass|
      step :step_one

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  ### Rescue

  def step_rescue_single_error_class
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: StandardError

      def step_one(string_param:, **)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def step_rescue_several_error_classes
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: [StandardError, ArgumentError]

      def step_one(string_param:, **)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def step_rescue_several_handler_methods
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: [StandardError, ArgumentError],
                 another_error_handler: NoMethodError

      def step_one(string_param:, **)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end

      def another_error_handler(error, **)
        add_error(:another_error, error.message)
      end
    end
  end

  def step_rescue_undefined_handler_method
    lambda do |_klass|
      step :step_one
      rescue_for another_error_handler: NoMethodError

      def step_one(string_param:, **)
        StubRaiseError.call
      end
    end
  end

  def rescue_for_without_step
    lambda do |_klass|
      rescue_for another_error_handler: NoMethodError

      def another_error_handler(error, **)
        add_error(:another_error, error.message)
      end
    end
  end

  ### Validations

  def validations
    lambda do |_klass|
      validate_inputs do
        required(:string_param).filled(:str?)
        required(:integer_param).filled(:int?)
      end
    end
  end

  def custom_validations
    lambda do |_klass|
      validate :first_validation

      def first_validation(string_param:, integer_param:, **)
        return if string_param.to_i == integer_param

        add_error(:invalid_string_param, 'Invalid string param')
      end
    end
  end

  ### Inner actions

  InnerAction = Class.new(Decouplio::Action) do
    validate :validate_inner_action_param

    step :multiply

    def multiply(inner_action_param:, **)
      ctx[:result] = inner_action_param * 2
    end

    def validate_inner_action_param(inner_action_param:, **)
      return if inner_action_param == 42

      add_error(:invalid_inner_action_param, 'Invalid inner_action_param')
    end
  end

  def inner_action
    lambda do |_klass|
      step InnerAction
      step :step_one

      def step_one(integer_param:, **)
        ctx[:result] = ctx[:result] - integer_param
      end
    end
  end

  ### Wrappers

  def wrappers
    lambda do |_klass|
      validate_inputs do
        required(:string_param).filled(:str?)
        required(:integer_param).filled(:int?)
      end

      step :step_one

      wrap klass: ClassWithWrapperMethod, method: :transaction do
        step :transaction_step_one
        step :transaction_step_two
      end
      rescue_for handler_step: ClassWithWrapperMethodError,
                 finish_him: true

      step :step_two

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def step_two(integer_param:, **)
        ctx[:result] = ctx[:result].to_i + integer_param
      end

      def transaction_step_one(integer_param:, **)
        ctx[:result] = ctx[:result].to_i + integer_param
      end

      def transaction_step_two(integer_param:, **)
        ctx[:result] = ctx[:result] + integer_param
      end
    end
  end
end
