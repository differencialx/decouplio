# frozen_string_literal: true

module Decouplio
  module Errors
    class OptionsValidationError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Octo::PALP_ON_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          Decouplio::Const::Validations::Octo::ON_ALLOWED_OPTIONS,
          Decouplio::Const::Validations::Octo::MANUAL_URL
        ]
      end
    end
  end
end
