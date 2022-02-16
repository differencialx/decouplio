# frozen_string_literal: true

require_relative 'messages'

module Decouplio
  module Errors
    class UndefinedStepMethodError < StandardError
      def initialize(instance_method)
        @instance_method = instance_method
      end

      def message
        Decouplio::Errors::Messages::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values
      end

      private

      def interpolation_values
        [
          "Undefined method --> #{@instance_method} <-- for"
        ]
      end
    end
  end
end
