# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/aide'

module Decouplio
  module Errors
    class AideCanNotBeFirstStepError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Aide::FIRST_STEP
      end

      def interpolation_values
        []
      end
    end
  end
end
