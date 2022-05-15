# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/octo'

module Decouplio
  module Errors
    class RequiredOptionsIsMissingForOctoError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Octo::REQUIRED_VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          format(
            Decouplio::Const::Validations::Octo::OPTIONS_IS_REQUIRED,
            @details
          ),
          Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Octo::MANUAL_URL
        ]
      end
    end
  end
end
