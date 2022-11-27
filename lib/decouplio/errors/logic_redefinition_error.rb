# frozen_string_literal: true

module Decouplio
  module Errors
    class LogicRedefinitionError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          format(
            Decouplio::Const::Validations::Logic::REDEFINITION,
            @errored_option
          )
        ]
      end
    end
  end
end
