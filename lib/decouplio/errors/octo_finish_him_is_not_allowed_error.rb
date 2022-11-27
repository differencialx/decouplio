# frozen_string_literal: true

module Decouplio
  module Errors
    class OctoFinishHimIsNotAllowedError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Octo::FINISH_HIM_IS_NOT_ALLOWED
      end

      def interpolation_values
        []
      end
    end
  end
end
