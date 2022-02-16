module Decouplio
  module Errors
    module Messages
      STEP_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
        Next options are not allowed for "step":
        %s

        Details:
        %s

        Allowed options are:
        %s

        Please read the menual about allowed options here:
        %s
      ERROR_MESSAGE
      STEP_ALLOWED_OPTIONS = %i[
        on_success
        on_failure
        finish_him
        if
        unless
      ]
      STEP_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
        on_success: <step name OR :finish_him>
        on_failure: <step name OR :finish_him>
        finish_him: :on_success
        finish_him: :on_failure
        if: <instance method symbol>
        unless: <instance method symbol>
      ALLOWED_OPTIONS
      STEP_MANUAL_URL = 'https://stub.step.manual.url'
      EXTRA_STEP_KEYS_ARE_NOT_ALLOWED = 'Please check if step options is allowed'


      FAIL_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
        Next options are not allowed for "fail":
        %s

        Details:
        %s

        Allowed options are:
        %s

        Please read the menual about allowed options here:
        %s
      ERROR_MESSAGE
      PASS_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
        Next options are not allowed for "pass":
        %s

        Details:
        %s

        Allowed options are:
        %s

        Please read the menual about allowed options here:
        %s
      ERROR_MESSAGE
      STRATEGY_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
        Next options are not allowed for "strg":
        %s

        Details:
        %s

        Allowed options are:
        %s

        Please read the menual about allowed options here:
        %s
      ERROR_MESSAGE
      SQUAD_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
        Next options are not allowed for "squad":
        %s

        "squad" doesn't allow any options
      ERROR_MESSAGE
      FAIL_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
        finish_him: true
        if: <instance method symbol>
        unless: <instance method symbol>
      ALLOWED_OPTIONS
      FAIL_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
        finish_him: true
        if: <instance method symbol>
        unless: <instance method symbol>
      ALLOWED_OPTIONS
      STRATEGY_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
        on_success: <step name OR :finish_him>
        on_failure: <step name OR :finish_him>
        finish_him: :on_success
        finish_him: :on_failure
        if: <instance method symbol>
        unless: <instance method symbol>
      ALLOWED_OPTIONS
      FAIL_MANUAL_URL = 'https://stub.fail.manual.url'
      PASS_MANUAL_URL = 'https://stub.pass.manual.url'
      STRATEGY_MANUAL_URL = 'https://stub.strategy.manual.url'
      SQUAD_MANUAL_URL = 'https://stub.squad.manual.url'
    end
  end
end
