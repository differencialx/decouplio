# frozen_string_literal: true

module Decouplio
  module Errors
    class LogicIsNotDefinedError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          format(
            Decouplio::Const::Validations::Logic::NOT_DEFINED,
            @errored_option
          )
        ]
      end
    end
  end
end
