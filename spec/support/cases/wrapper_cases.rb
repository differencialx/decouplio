# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module WrapperCases
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def wrappers
    lambda do |_klass|
      step :step_one

      wrap klass: ClassWithWrapperMethod, method: :transaction do
        step :transaction_step_one
        step :transaction_step_two
      end
      rescue_for handler_step: ClassWithWrapperMethodError

      step :step_two

      def handler_step(error, **)
        add_error(wrapper_error: error.message)
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
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
# rubocop:enable Lint/NestedMethodDefinition
