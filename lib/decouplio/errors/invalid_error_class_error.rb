# frozen_string_literal: true

module Decouplio
  module Errors
    class InvalidErrorClassError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          format(
            Decouplio::Const::Validations::Resq::NOT_ALLOWED_EXCEPTION_CLASS,
            @errored_option
          ),
          format(
            Decouplio::Const::Validations::Resq::ERROR_CLASS_INHERITANCE,
            @details
          ),
          Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Resq::MANUAL_URL
        ]
      end
    end
  end
end
