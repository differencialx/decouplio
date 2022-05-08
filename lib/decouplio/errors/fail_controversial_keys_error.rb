# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/fail'

module Decouplio
  module Errors
    class FailControversialKeysError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          @errored_option,
          format(
            Decouplio::Const::Validations::Fail::CONTROVERSIAL_KEYS,
            *@details
          ),
          Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Fail::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
