# frozen_string_literal: true

module ActionCases
  def steps
    lambda do |_klass|
      step :step_one

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

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
      rescue_for error: ClassWithWrapperMethodError,
                 handler: :handler_step,
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
