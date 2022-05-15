# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/octo'

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
