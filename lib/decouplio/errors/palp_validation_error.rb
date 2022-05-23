# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/palp'

module Decouplio
  module Errors
    class PalpValidationError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Palp::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Validations::Palp::DOES_NOT_ALLOW_ANY_OPTION,
          Decouplio::Const::Validations::Palp::MANUAL_URL
        ]
      end
    end
  end
end
