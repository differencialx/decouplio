# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/deny'

module Decouplio
  module Errors
    class DenyCanNotBeFirstStepError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Deny::FIRST_STEP
      end

      def interpolation_values
        []
      end
    end
  end
end
