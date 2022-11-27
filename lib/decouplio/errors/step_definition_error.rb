# frozen_string_literal: true

module Decouplio
  module Errors
    class StepDefinitionError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Common::STEP_DEFINITION
      end

      def interpolation_values
        [
          @errored_option
        ]
      end
    end
  end
end
