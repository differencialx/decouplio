# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/fail'

module Decouplio
  module Errors
    class StepIsNotDefinedForAideError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Common::STEP_IS_NOT_DEFINED,
            @details
          ),
          Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Aide::MANUAL_URL
        ]
      end
    end
  end
end
