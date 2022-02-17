require_relative 'step'
require_relative 'errors/options_validation_error'

module Decouplio
  class OptionsValidator
    def self.call(name:, type:, options:, action_class:)
      new(name: name, type: type, options: options, action_class: action_class).call
    end

    def initialize(name:, type:, options:, action_class:)
      @type = type
      @options = options
      @name = name
      @action_class = action_class
    end

    def call
      case @type
      when Decouplio::Step::STEP_TYPE
        validate_step
      when Decouplio::Step::FAIL_TYPE
        validate_fail
      when Decouplio::Step::PASS_TYPE
        validate_pass
      when Decouplio::Step::STRATEGY_TYPE
        validate_strategy
      when Decouplio::Step::SQUAD_TYPE
        validate_squad
      end
    end

    private

    def validate_step
      check_step_extra_keys
      check_step_method_existence
      check_step_finish_him
      # TODO: check reccursion call for on_success and on_failure
    end

    def validate_fail
      check_fail_extra_keys
      check_fail_method_existence
      check_fail_finish_him
    end

    def validate_pass
    end

    def validate_if
    end

    def validate_unless
    end

    def validate_strategy
    end

    def validate_squad
    end

    def raise_validation_error(message)
      raise Decouplio::Errors::OptionsValidationError, message
    end

    def compose_message(message, *interpolation_values)
      message % interpolation_values
    end

    def check_step_extra_keys
      extra_keys = @options.keys - STEP_ALLOWED_OPTIONS

      if extra_keys.size > 0
        raise_validation_error(
          compose_message(
            STEP_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(*extra_keys).to_s,
            EXTRA_STEP_KEYS_ARE_NOT_ALLOWED,
            STEP_ALLOWED_OPTIONS_MESSAGE,
            STEP_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_fail_extra_keys
      extra_keys = @options.keys - FAIL_ALLOWED_OPTIONS

      if extra_keys.size > 0
        raise_validation_error(
          compose_message(
            FAIL_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(*extra_keys).to_s,
            OPTIONS_IS_NOT_ALLOWED % [extra_keys.join(', ')],
            FAIL_ALLOWED_OPTIONS,
            FAIL_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_step_method_existence
      @options.slice(*STEP_CHECK_METHOD_EXISTENCE_OPTIONS).each do |option_key, option_value|
        unless @action_class.public_instance_methods.include?(option_value)
          raise_validation_error(
            compose_message(
              STEP_VALIDATION_ERROR_MESSAGE,
              YELLOW,
              @options.slice(option_key).to_s,
              METHOD_IS_NOT_DEFINED % [option_value],
              STEP_ALLOWED_OPTIONS_MESSAGE,
              STEP_MANUAL_URL,
              NO_COLOR
            )
          )
        end
      end
    end

    def check_fail_method_existence
      @options.slice(*FAIL_CHECK_METHOD_EXISTENCE_OPTIONS).each do |option_key, option_value|
        unless @action_class.public_instance_methods.include?(option_value)
          raise_validation_error(
            compose_message(
              FAIL_VALIDATION_ERROR_MESSAGE,
              YELLOW,
              @options.slice(option_key).to_s,
              METHOD_IS_NOT_DEFINED % [option_value],
              FAIL_ALLOWED_OPTIONS,
              FAIL_MANUAL_URL,
              NO_COLOR
            )
          )
        end
      end
    end

    def check_step_finish_him
      finish_him_value = @options.dig(:finish_him)

      return unless finish_him_value && @options.has_key?(:finish_him)

      unless ALLOWED_STEP_FINISH_HIM_VALUES.include?(finish_him_value)
        raise_validation_error(
          compose_message(
            STEP_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(:finish_him).to_s,
            WRONG_FINISH_HIM_VALUE % [finish_him_value],
            STEP_ALLOWED_OPTIONS_MESSAGE,
            STEP_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_fail_finish_him
      finish_him_value = @options.dig(:finish_him)

      return unless finish_him_value && @options.has_key?(:finish_him)

      unless ALLOWED_FAIL_FINISH_HIM_VALUES.include?(finish_him_value)
        raise_validation_error(
          compose_message(
            FAIL_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(:finish_him).to_s,
            WRONG_FINISH_HIM_VALUE % [finish_him_value],
            FAIL_ALLOWED_OPTIONS,
            FAIL_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    # Black        0;30     Dark Gray     1;30
    # Red          0;31     Light Red     1;31
    # Green        0;32     Light Green   1;32
    # Brown/Orange 0;33     Yellow        1;33
    # Blue         0;34     Light Blue    1;34
    # Purple       0;35     Light Purple  1;35
    # Cyan         0;36     Light Cyan    1;36
    # Light Gray   0;37     White         1;37
    YELLOW = "\033[1;33m"
    NO_COLOR = "\033[0m"
    STEP_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
      %s
      Next options are not allowed for "step":
      %s

      Details:
      %s

      Allowed options are:
      %s

      Please read the menual about allowed options here:
      %s
      %s
    ERROR_MESSAGE

    STEP_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      on_success
      on_failure
      if
      unless
    ]
    STEP_ALLOWED_OPTIONS = %i[
      on_success
      on_failure
      finish_him
      if
      unless
      ].freeze
    ALLOWED_STEP_FINISH_HIM_VALUES = [
      :on_success,
      :on_failure,
      true
    ].freeze

    STEP_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
      on_success: <step name OR :finish_him>
      on_failure: <step name OR :finish_him>
      finish_him: :on_success
      finish_him: :on_failure
      if: <instance method symbol>
      unless: <instance method symbol>
    ALLOWED_OPTIONS
    STEP_MANUAL_URL = 'https://stub.step.manual.url'
    EXTRA_STEP_KEYS_ARE_NOT_ALLOWED = 'Please check if step option is allowed'


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

    FAIL_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
      finish_him: true
      if: <instance method symbol>
      unless: <instance method symbol>
    ALLOWED_OPTIONS

    FAIL_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      if
      unless
    ]
    FAIL_ALLOWED_OPTIONS = %i[
      finish_him
      if
      unless
    ]
    ALLOWED_FAIL_FINISH_HIM_VALUES = [true].freeze
    FAIL_MANUAL_URL = 'https://stub.fail.manual.url'
    OPTIONS_IS_NOT_ALLOWED = '"%s" option(s) is not allowed for "fail"'

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
    PASS_MANUAL_URL = 'https://stub.pass.manual.url'
    STRATEGY_MANUAL_URL = 'https://stub.strategy.manual.url'
    SQUAD_MANUAL_URL = 'https://stub.squad.manual.url'

    WRONG_FINISH_HIM_VALUE = '"finish_him" does not allow "%s" value'
    METHOD_IS_NOT_DEFINED = 'Method "%s" is not defined'
  end
end
