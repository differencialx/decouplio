# frozen_string_literal: true

module Decouplio
  module Errors
    class ActionClassError < Decouplio::Errors::BaseError
      def initialize(step_type:, errored_option:)
        super(errored_option: errored_option)
        @step_type = step_type
      end

      def template
        Decouplio::Const::Validations::ActionOptionClass::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @step_type,
          @errored_option
        ]
      end
    end
  end
end
