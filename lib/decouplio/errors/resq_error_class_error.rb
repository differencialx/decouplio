# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/resq'

module Decouplio
  module Errors
    class ResqErrorClassError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          format(
            Decouplio::Const::Validations::Resq::INVALID_ERROR_CLASS_VALUE,
            @errored_option
          ),
          format(
            Decouplio::Const::Validations::Resq::WRONG_ERROR_CLASS,
            @details
          ),
          Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Resq::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
