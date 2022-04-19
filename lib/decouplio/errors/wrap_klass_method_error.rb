require_relative 'base_error'
require_relative '../const/validations/wrap'

module Decouplio
  module Errors
    class WrapKlassMethodError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          @errored_option,
          Decouplio::Const::Validations::Wrap::KLASS_AND_METHOD_PRESENCE,
          Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Wrap::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
