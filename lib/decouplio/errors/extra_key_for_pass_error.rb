# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/pass'

module Decouplio
  module Errors
    class ExtraKeyForPassError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          @errored_option,
          format(
            Decouplio::Const::Validations::Pass::OPTIONS_IS_NOT_ALLOWED,
            @details
          ),
          Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Pass::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
