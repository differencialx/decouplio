# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/wrap'

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
