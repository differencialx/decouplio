# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/logic'

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
