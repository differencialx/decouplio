# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Pass
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          %s
          Next options are not allowed for "pass":
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
          finish_him: true
          if: <instance method symbol>
          unless: <instance method symbol>
        ALLOWED_OPTIONS
        MANUAL_URL = 'https://stub.pass.manual.url'
        OPTIONS_IS_NOT_ALLOWED = '"%s" option(s) is not allowed for "pass"'
        METHOD_NOT_DEFINED = 'pass :%s'
      end
    end
  end
end
