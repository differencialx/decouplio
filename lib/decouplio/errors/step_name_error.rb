# frozen_string_literal: true

module Decouplio
  module Errors
    class StepNameError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Common::STEP_NAME
      end

      def interpolation_values
        [
          @errored_option
        ]
      end
    end
  end
end
