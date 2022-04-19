require_relative 'base_error'
require_relative '../const/validations/wrap'

module Decouplio
  module Errors
    class WrapFinishHimError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          @errored_option,
          format(
            Decouplio::Const::Validations::Common::WRONG_FINISH_HIM_VALUE,
            @details
          ),
          Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Wrap::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
