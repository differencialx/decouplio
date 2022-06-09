# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Aide
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          Next options are not allowed for "aide":
          %s

          Details:
          %s

          Allowed options are:
          %s

          Please read the manual about allowed options here:
          %s
        ERROR_MESSAGE

        ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
          on_success: <step name OR :finish_him>
          on_failure: <step name OR :finish_him>
          finish_him: :on_success
          finish_him: :on_failure
          finish_him: true
          if: <instance method symbol>
          unless: <instance method symbol>
        ALLOWED_OPTIONS
        MANUAL_URL = 'https://stub.aide.manual.url'
        OPTIONS_IS_NOT_ALLOWED = '"%s" option(s) is not allowed for "aide"'
        METHOD_NOT_DEFINED = 'aide :%s'
        CONTROVERSIAL_KEYS = '"%s" option(s) is not allowed along with "%s" option(s)'
        FIRST_STEP = '"aide" can not be the first step'
      end
    end
  end
end
