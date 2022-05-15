# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Octo
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          Next options are not allowed for "octo":
          %s

          Details:
          %s

          Allowed options are:
          %s

          Please read the manual about allowed options here:
          %s
        ERROR_MESSAGE
        REQUIRED_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          Details:
          %s

          Allowed options are:
          %s

          Please read the manual about allowed options here:
          %s
        ERROR_MESSAGE
        ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
          ctx_key: <ctx key with strategy name to be used for strategy mapping> - required
          if: <instance method symbol>
          unless: <instance method symbol>
        ALLOWED_OPTIONS
        OPTIONS_IS_NOT_ALLOWED = '"%s" option(s) is not allowed for "octo"'
        MANUAL_URL = 'https://stub.strategy.manual.url'
        OPTIONS_IS_REQUIRED = 'Next option(s) "%s" are required for "octo"'
        CONTROVERSIAL_KEYS = '"%s" option(s) is not allowed along with "%s" option(s)'
        PALPS_IS_NOT_DEFINED = 'Next palp(s): "%s" is not difined'
        OCTO_BLOCK = 'Block for "octo" is not defined'
      end
    end
  end
end
