# frozen_string_literal: true

module Decouplio
  module Errors
    class OctoBlockIsNotDefinedError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Octo::OCTO_BLOCK
      end

      def interpolation_values
        []
      end
    end
  end
end
