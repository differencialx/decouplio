# frozen_string_literal: true

module Decouplio
  module Errors
    class ResqHandlerMethodError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          format(
            Decouplio::Const::Validations::Resq::NOT_ALLOWED_HANDLER_METHOD_VALUE,
            @errored_option
          ),
          Decouplio::Const::Validations::Resq::HANDLER_METHOD_SHOULD_BE_A_SYMBOL,
          Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Resq::MANUAL_URL
        ]
      end
    end
  end
end
