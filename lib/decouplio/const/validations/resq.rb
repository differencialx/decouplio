# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Resq
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          Next options are not allowed for "resq":
          %s

          Details:
          %s

          Allowed options are:
          %s

          Please read the manual about allowed options here:
          %s
        ERROR_MESSAGE
        ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
          <method name> => <exception class>
          OR
          <method name> => [<excpetion class one>, <exception class two>]

          RESQ can have several handler methods, e.g.:
          logic do
            step :some_step
            resq first_handler: [NoMethodError, ArgumentError],
                second_handler: StandardError
          end

          def some_step(**)
            ctx[:result] = <code which may raise an error>
          end

          def first_handler(error, **)
            # Error handling code
          end

          def second_handler(error, **)
            # Error handling code
          end

        ALLOWED_OPTIONS

        DEFINITION_ERROR_MESSAGE = <<~ERROR
          Details:
          "resq" should be defined only after:
          %s

          Please read the manual about allowed options here:
          %s
        ERROR

        DOES_NOT_ALLOW_OPTIONS = '"resq" does not allow "%s" option(s)'
        MANUAL_URL = 'https://stub.resq.manual.url'
        PLEASE_DEFINE_HANDLER_METHOD = 'Please define "%s" method'
        HANDLER_METHOD_SHOULD_BE_A_SYMBOL = 'Handler method should be a symbol'
        ERROR_CLASS_INHERITANCE = 'Please use exception class. %s does not inherited from Exception class'
        INVALID_ERROR_CLASS_VALUE = 'Invalid handler class value "%s"'
        WRONG_ERROR_CLASS = 'Please specify exception class(es) for "%s"'
        NOT_ALLOWED_HANDLER_METHOD_VALUE = '"%s" is not allowed as a handler method for "resq"'
        NOT_ALLOWED_EXCEPTION_CLASS = '"%s" class is not allowed for "resq"'
      end
    end
  end
end
