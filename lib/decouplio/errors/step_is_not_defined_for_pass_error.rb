# frozen_string_literal: true

module Decouplio
  module Errors
    class StepIsNotDefinedForPassError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Common::STEP_IS_NOT_DEFINED,
            @details
          ),
          Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Pass::MANUAL_URL
        ]
      end
    end
  end
end
