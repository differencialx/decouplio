# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Doby
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          Next options are not allowed for "doby":
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
          if: <instance method symbol>
          unless: <instance method symbol>
        ALLOWED_OPTIONS
        MANUAL_URL = 'https://stub.doby.manual.url'
        OPTIONS_IS_NOT_ALLOWED = '"%s" option(s) is not allowed for "doby"'
        METHOD_NOT_DEFINED = 'doby :%s'
        CONTROVERSIAL_KEYS = '"%s" option(s) is not allowed along with "%s" option(s)'
      end
    end
  end
end
