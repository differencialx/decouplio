# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/resq'

module Decouplio
  module Errors
    class ResqDefinitionError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Resq::DEFINITION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          Decouplio::Const::Types::MAIN_FLOW_TYPES.join("\n"),
          Decouplio::Const::Validations::Resq::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
