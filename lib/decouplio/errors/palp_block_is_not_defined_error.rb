# frozen_string_literal: true

module Decouplio
  module Errors
    class PalpBlockIsNotDefinedError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Palp::NOT_DEFINED
      end

      def interpolation_values
        []
      end
    end
  end
end
