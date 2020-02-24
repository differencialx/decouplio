# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module OnFailureCases
  def on_failure
    lambda do |_klass|
      step :step_one
      rescue_for handler: StandardError
      step :on_fail_step, :on_failure

      def step_one(**)
        StubRaiseError.call
      end

      def handler(error, **)
        add_error(step_one_error: error.message)
      end

      def on_fail_step(**)
        ctx[:fail_step_result] = 'Failure'
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
