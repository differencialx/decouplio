# frozen_string_literal: true

require_relative 'base_error'
require_relative '../const/validations/step'

module Decouplio
  module Errors
    class ExtraKeyForStepError < Decouplio::Errors::BaseError
      def template
        Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE
      end

      def interpolation_values
        [
          @errored_option,
          Decouplio::Const::Validations::Step::EXTRA_KEYS_ARE_NOT_ALLOWED,
          Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Step::MANUAL_URL
        ]
      end
    end
  end
end
