# frozen_string_literal: true

module Decouplio
  module Errors
    class InvalidWrapNameError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Validations::Wrap::NAME_IS_EMPTY,
          Decouplio::Const::Validations::Wrap::SPECIFY_NAME,
          Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Wrap::MANUAL_URL
        ]
      end
    end
  end
end
