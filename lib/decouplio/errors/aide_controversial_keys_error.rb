# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/aide'

module Decouplio
  module Errors
    class AideControversialKeysError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Aide::CONTROVERSIAL_KEYS,
            *@details
          ),
          Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Aide::MANUAL_URL
        ]
      end
    end
  end
end
