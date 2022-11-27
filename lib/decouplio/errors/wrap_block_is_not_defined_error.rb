# frozen_string_literal: true

module Decouplio
  module Errors
    class WrapBlockIsNotDefinedError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Wrap::NOT_DEFINED
      end

      def interpolation_values
        []
      end
    end
  end
end
