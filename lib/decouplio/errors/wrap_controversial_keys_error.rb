# frozen_string_literal: true

module Decouplio
  module Errors
    class WrapControversialKeysError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Wrap::CONTROVERSIAL_KEYS,
            *@details
          ),
          Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Wrap::MANUAL_URL
        ]
      end
    end
  end
end
