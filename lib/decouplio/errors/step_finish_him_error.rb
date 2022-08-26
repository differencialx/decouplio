# frozen_string_literal: true

module Decouplio
  module Errors
    class StepFinishHimError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          format(
            Decouplio::Const::Validations::Common::WRONG_FINISH_HIM_VALUE,
            @details
          ),
          Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Step::MANUAL_URL
        ]
      end
    end
  end
end
