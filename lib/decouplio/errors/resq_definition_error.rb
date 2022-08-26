# frozen_string_literal: true

module Decouplio
  module Errors
    class ResqDefinitionError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Resq::DEFINITION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Types::MAIN_FLOW_TYPES.join("\n"),
          Decouplio::Const::Validations::Resq::MANUAL_URL
        ]
      end
    end
  end
end
