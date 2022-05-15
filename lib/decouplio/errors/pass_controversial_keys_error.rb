# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/pass'

module Decouplio
  module Errors
    class PassControversialKeysError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Pass::CONTROVERSIAL_KEYS,
            *@details
          ),
          Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Pass::MANUAL_URL
        ]
      end
    end
  end
end
