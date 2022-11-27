# frozen_string_literal: true

module Decouplio
  module Errors
    class StepIsNotDefinedForStepError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Common::STEP_IS_NOT_DEFINED,
            @details
          ),
          Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Step::MANUAL_URL
        ]
      end
    end
  end
end
