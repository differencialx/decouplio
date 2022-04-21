# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Step
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          %s
          Next options are not allowed for "step":
          %s

          Details:
          %s

          Allowed options are:
          %s

          Please read the manual about allowed options here:
          %s
          %s
        ERROR_MESSAGE
        ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
          on_success: <step name OR :finish_him>
          on_failure: <step name OR :finish_him>
          finish_him: :on_success
          finish_him: :on_failure
          if: <instance method symbol>
          unless: <instance method symbol>
        ALLOWED_OPTIONS
        MANUAL_URL = 'https://stub.step.manual.url'
        EXTRA_KEYS_ARE_NOT_ALLOWED = 'Please check if step option is allowed'
        METHOD_NOT_DEFINED = 'step :%s'
      end
    end
  end
end
