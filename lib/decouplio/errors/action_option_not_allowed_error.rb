# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/action_option'

module Decouplio
  module Errors
    class ActionOptionNotAllowedError < Decouplio::Errors::BaseError
      def initialize(step_type:, errored_option:)
        super(errored_option: errored_option)
        @step_type = step_type
      end

      def template
        Decouplio::Const::Validations::ActionOption::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          Decouplio::Const::Colors::YELLOW,
          @step_type,
          @errored_option,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
    end
  end
end
