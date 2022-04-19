require_relative 'base_error'
require_relative '../const/validations/wrap'

module Decouplio
  module Errors
    class ExtraKeyForWrapError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          @errored_option,
          Decouplio::Const::Validations::Wrap::EXTRA_KEYS_ARE_NOT_ALLOWED,
          Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Wrap::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
