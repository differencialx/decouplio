# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module StepCases
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
end
# rubocop:enable Lint/NestedMethodDefinition
