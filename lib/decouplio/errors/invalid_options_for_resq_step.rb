# frozen_string_literal: true

module Decouplio
  module Errors
    class InvalidOptionsForResqStep < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Resq::OPTIONS_DEFINITION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          Decouplio::Const::Validations::Resq::MANUAL_URL
        ]
      end
    end
  end
end
