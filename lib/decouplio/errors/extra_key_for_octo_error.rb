# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/octo'

module Decouplio
  module Errors
    class ExtraKeyForOctoError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Octo::OPTIONS_IS_NOT_ALLOWED,
            @details
          ),
          Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Octo::MANUAL_URL
        ]
      end
    end
  end
end
