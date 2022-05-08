# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/action'

module Decouplio
  module Errors
    class ActionRedefinitionError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Action::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          @errored_option,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
