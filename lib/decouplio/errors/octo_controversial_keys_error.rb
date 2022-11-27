# frozen_string_literal: true

module Decouplio
  module Errors
    class OctoControversialKeysError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Octo::CONTROVERSIAL_KEYS,
            *@details
          ),
          Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Octo::MANUAL_URL
        ]
      end
    end
  end
end
