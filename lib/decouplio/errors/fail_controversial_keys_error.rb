# frozen_string_literal: true

module Decouplio
  module Errors
    class FailControversialKeysError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Fail::CONTROVERSIAL_KEYS,
            *@details
          ),
          Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Fail::MANUAL_URL
        ]
      end
    end
  end
end
