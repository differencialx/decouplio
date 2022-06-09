# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/doby'

module Decouplio
  module Errors
    class DobyFinishHimError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Doby::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Common::WRONG_FINISH_HIM_VALUE,
            @details
          ),
          Decouplio::Const::Validations::Doby::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Doby::MANUAL_URL
        ]
      end
    end
  end
end