# frozen_string_literal: true

module Decouplio
  module Errors
    class ResqErrorClassError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          format(
            Decouplio::Const::Validations::Resq::INVALID_ERROR_CLASS_VALUE,
            @errored_option
          ),
          format(
            Decouplio::Const::Validations::Resq::WRONG_ERROR_CLASS,
            @details
          ),
          Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Resq::MANUAL_URL
        ]
      end
    end
  end
end
