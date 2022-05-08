# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Wrap
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          %s
          Next options are not allowed for "wrap":
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
          klass: <class which implements wrap method, "method" option should be present>
          method: <method name for wrapping, "klass" option should be present>
        ALLOWED_OPTIONS
        MANUAL_URL = 'https://stub.wrap.manual.url'
        EXTRA_KEYS_ARE_NOT_ALLOWED = 'Please check if wrap option is allowed'
        KLASS_AND_METHOD_PRESENCE = '"klass" options should be passed along with "method" option'
        METHOD_IS_NOT_DEFINED_FOR_KLASS = 'Method "%s" is not defined for "%s" class'
        NAME_IS_EMPTY = 'wrap name is empty'
        SPECIFY_NAME = 'Please specify name for "wrap"'
        CONTROVERSIAL_KEYS = '"%s" option(s) is not allowed along with "%s" option(s)'
      end
    end
  end
end
