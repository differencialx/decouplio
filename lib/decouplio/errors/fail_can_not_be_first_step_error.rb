# frozen_string_literal: true

module Decouplio
  module Errors
    class FailCanNotBeFirstStepError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Fail::FIRST_STEP
      end

      def interpolation_values
        []
      end
    end
  end
end
