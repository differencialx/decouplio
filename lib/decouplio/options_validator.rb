require_relative 'step'
require_relative 'errors/options_validation_error'

module Decouplio
  class OptionsValidator
    def self.call(name:, type:, options:, action_class:, step_names:)
      new(name: name, type: type, options: options, action_class: action_class, step_names: step_names).call
    end

    def initialize(name:, type:, options:, action_class:, step_names:)
      @type = type
      @options = options
      @name = name
      @action_class = action_class
      @step_names = step_names
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
      when Decouplio::Step::WRAP_TYPE
        validate_wrap
      end
    end

    private

    def validate_step
      check_step_presence
      check_step_method_is_defined
      check_step_extra_keys
      check_step_method_existence
      check_step_finish_him
      # TODO: check reccursion call for on_success and on_failure
    end

    def validate_fail
      check_fail_method_is_defined
      check_fail_extra_keys
      check_fail_method_existence
      check_fail_finish_him
    end

    def validate_pass
      check_pass_method_is_defined
      check_pass_extra_keys
      check_pass_method_existence
      check_pass_finish_him
    end

    def validate_strategy
      check_strategy_required_keys
      check_strategy_extra_keys
      check_strategy_method_existence
    end

    def validate_wrap
      check_wrap_name
      check_wrap_step_presence
      check_wrap_method_existence
      check_wrap_extra_keys
      check_wrap_finish_him
      check_wrap_klass_method_presence
      check_klass_method_is_defined
    end

    def raise_validation_error(message)
      # TODO: consider to create separate error class for each case
      # with predefined messages
      raise Decouplio::Errors::OptionsValidationError, message
    end

    def compose_message(message, *interpolation_values)
      # TODO: move message composition to separate class it will simplfy
      # error message testing
      message % interpolation_values
    end

    def check_step_method_is_defined
      return if @options.has_key?(:action)

      unless @action_class.public_instance_methods.include?(@name)
        raise_validation_error(
          compose_message(
            STEP_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            STEP_METHOD_NOT_DEFINED % @name,
            METHOD_IS_NOT_DEFINED % [@name],
            STEP_ALLOWED_OPTIONS_MESSAGE,
            STEP_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_fail_method_is_defined
      unless @action_class.public_instance_methods.include?(@name)
        raise_validation_error(
          compose_message(
            FAIL_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            FAIL_METHOD_NOT_DEFINED % @name,
            METHOD_IS_NOT_DEFINED % [@name],
            FAIL_ALLOWED_OPTIONS_MESSAGE,
            FAIL_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_pass_method_is_defined
      unless @action_class.public_instance_methods.include?(@name)
        raise_validation_error(
          compose_message(
            PASS_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            PASS_METHOD_NOT_DEFINED % @name,
            METHOD_IS_NOT_DEFINED % [@name],
            PASS_ALLOWED_OPTIONS_MESSAGE,
            PASS_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_step_presence
      @options.slice(*STEP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure].include?(option_key) && option_value == :finish_him

        unless @step_names.keys.include?(option_value)
          raise_validation_error(
            compose_message(
              STEP_VALIDATION_ERROR_MESSAGE,
              YELLOW,
              @options.slice(option_key).to_s,
              STEP_IS_NOT_DEFINED % [option_value],
              STEP_ALLOWED_OPTIONS_MESSAGE,
              STEP_MANUAL_URL,
              NO_COLOR
            )
          )
        end
      end
    end

    def check_wrap_step_presence
      @options.slice(*WRAP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure].include?(option_key) && option_value == :finish_him

        unless @step_names.keys.include?(option_value)
          raise_validation_error(
            compose_message(
              WRAP_VALIDATION_ERROR_MESSAGE,
              YELLOW,
              @options.slice(option_key).to_s,
              STEP_IS_NOT_DEFINED % [option_value],
              WRAP_ALLOWED_OPTIONS_MESSAGE,
              WRAP_MANUAL_URL,
              NO_COLOR
            )
          )
        end
      end
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
            FAIL_OPTIONS_IS_NOT_ALLOWED % [extra_keys.join(', ')],
            FAIL_ALLOWED_OPTIONS_MESSAGE,
            FAIL_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_pass_extra_keys
      extra_keys = @options.keys - PASS_ALLOWED_OPTIONS

      if extra_keys.size > 0
        raise_validation_error(
          compose_message(
            PASS_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(*extra_keys).to_s,
            PASS_OPTIONS_IS_NOT_ALLOWED % [extra_keys.join(', ')],
            PASS_ALLOWED_OPTIONS_MESSAGE,
            PASS_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_strategy_extra_keys
      extra_keys = @options.keys - STRATEGY_ALLOWED_OPTIONS

      if extra_keys.size > 0
        raise_validation_error(
          compose_message(
            STRATEGY_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(*extra_keys).to_s,
            STRATEGY_OPTIONS_IS_NOT_ALLOWED % [extra_keys.join(', ')],
            STRATEGY_ALLOWED_OPTIONS_MESSAGE,
            STRATEGY_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_wrap_extra_keys
      extra_keys = @options.keys - WRAP_ALLOWED_OPTIONS

      if extra_keys.size > 0
        raise_validation_error(
          compose_message(
            WRAP_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(*extra_keys).to_s,
            EXTRA_WRAP_KEYS_ARE_NOT_ALLOWED,
            WRAP_ALLOWED_OPTIONS_MESSAGE,
            WRAP_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_strategy_required_keys
      unless (STRATEGY_REQUIRED_KEYS - @options.keys).size == 0
        raise_validation_error(
          compose_message(
            STRATEGY_REQUIRED_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            STRATEGY_OPTIONS_IS_REQUIRED % [STRATEGY_REQUIRED_KEYS.join(', ')],
            STRATEGY_ALLOWED_OPTIONS_MESSAGE,
            STRATEGY_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_step_method_existence
      @options.slice(*STEP_CHECK_METHOD_EXISTENCE_OPTIONS).each do |option_key, option_value|
        next if %i[on_success on_failure].include?(option_key) && option_value == :finish_him
        next if @step_names[option_value] == :wrap

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
              FAIL_ALLOWED_OPTIONS_MESSAGE,
              FAIL_MANUAL_URL,
              NO_COLOR
            )
          )
        end
      end
    end

    def check_pass_method_existence
      @options.slice(*PASS_CHECK_METHOD_EXISTENCE_OPTIONS).each do |option_key, option_value|
        unless @action_class.public_instance_methods.include?(option_value)
          raise_validation_error(
            compose_message(
              PASS_VALIDATION_ERROR_MESSAGE,
              YELLOW,
              @options.slice(option_key).to_s,
              METHOD_IS_NOT_DEFINED % [option_value],
              PASS_ALLOWED_OPTIONS_MESSAGE,
              PASS_MANUAL_URL,
              NO_COLOR
            )
          )
        end
      end
    end

    def check_strategy_method_existence
      @options.slice(*STRATEGY_CHECK_METHOD_EXISTENCE_OPTIONS).each do |option_key, option_value|
        unless @action_class.public_instance_methods.include?(option_value)
          raise_validation_error(
            compose_message(
              STRATEGY_VALIDATION_ERROR_MESSAGE,
              YELLOW,
              @options.slice(option_key).to_s,
              METHOD_IS_NOT_DEFINED % [option_value],
              STRATEGY_ALLOWED_OPTIONS_MESSAGE,
              STRATEGY_MANUAL_URL,
              NO_COLOR
            )
          )
        end
      end
    end

    def check_wrap_method_existence
      @options.slice(*WRAP_CHECK_METHOD_EXISTENCE_OPTIONS).each do |option_key, option_value|
        next if %i[on_success on_failure].include?(option_key) && option_value == :finish_him

        unless @action_class.public_instance_methods.include?(option_value)
          raise_validation_error(
            compose_message(
              WRAP_VALIDATION_ERROR_MESSAGE,
              YELLOW,
              @options.slice(option_key).to_s,
              METHOD_IS_NOT_DEFINED % [option_value],
              WRAP_ALLOWED_OPTIONS_MESSAGE,
              WRAP_MANUAL_URL,
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
            FAIL_ALLOWED_OPTIONS_MESSAGE,
            FAIL_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_pass_finish_him
      finish_him_value = @options.dig(:finish_him)

      return unless finish_him_value && @options.has_key?(:finish_him)

      unless ALLOWED_FAIL_FINISH_HIM_VALUES.include?(finish_him_value)
        raise_validation_error(
          compose_message(
            PASS_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(:finish_him).to_s,
            WRONG_FINISH_HIM_VALUE % [finish_him_value],
            PASS_ALLOWED_OPTIONS_MESSAGE,
            PASS_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_strategy_finish_him
      finish_him_value = @options.dig(:finish_him)

      return unless finish_him_value && @options.has_key?(:finish_him)

      unless ALLOWED_FAIL_FINISH_HIM_VALUES.include?(finish_him_value)
        raise_validation_error(
          compose_message(
            PASS_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(:finish_him).to_s,
            WRONG_FINISH_HIM_VALUE % [finish_him_value],
            PASS_ALLOWED_OPTIONS_MESSAGE,
            PASS_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_wrap_finish_him
      finish_him_value = @options.dig(:finish_him)

      return unless finish_him_value && @options.has_key?(:finish_him)

      unless ALLOWED_WRAP_FINISH_HIM_VALUES.include?(finish_him_value)
        raise_validation_error(
          compose_message(
            WRAP_VALIDATION_ERROR_MESSAGE,
            YELLOW,
            @options.slice(:finish_him).to_s,
            WRONG_FINISH_HIM_VALUE % [finish_him_value],
            WRAP_ALLOWED_OPTIONS_MESSAGE,
            WRAP_MANUAL_URL,
            NO_COLOR
          )
        )
      end
    end

    def check_wrap_klass_method_presence
      klass_method_options = @options.slice(:klass, :method)
      klass_method_options_size = klass_method_options.size

      return if klass_method_options_size == 0 || klass_method_options_size == 2

      raise_validation_error(
        compose_message(
          WRAP_VALIDATION_ERROR_MESSAGE,
          YELLOW,
          klass_method_options.to_s,
          KLASS_AND_METHOD_PRESENCE,
          WRAP_ALLOWED_OPTIONS_MESSAGE,
          WRAP_MANUAL_URL,
          NO_COLOR
        )
      )
    end

    def check_klass_method_is_defined
      klass_method_options = @options.slice(:klass, :method)

      return if klass_method_options.size == 0

      return if @options[:klass].public_methods.include?(@options[:method])

      raise_validation_error(
        compose_message(
          WRAP_VALIDATION_ERROR_MESSAGE,
          YELLOW,
          klass_method_options.to_s,
          METHOD_IS_NOT_DEFINED_FOR_KLASS % [@options[:method], @options[:klass]],
          WRAP_ALLOWED_OPTIONS_MESSAGE,
          WRAP_MANUAL_URL,
          NO_COLOR
        )
      )
    end

    def check_wrap_name
      return if @name.is_a?(Symbol)

      raise_validation_error(
        compose_message(
          WRAP_VALIDATION_ERROR_MESSAGE,
          YELLOW,
          WRAP_NAME_IS_EMPTY,
          SPECIFY_WRAP_NAME,
          WRAP_ALLOWED_OPTIONS_MESSAGE,
          WRAP_MANUAL_URL,
          NO_COLOR
        )
      )

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


    # *************************************************
    # STEP
    # *************************************************
    STEP_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
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

    STEP_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      on_success
      on_failure
      if
      unless
    ]
    STEP_CHECK_STEP_PRESENCE = %i[
      on_success
      on_failure
    ].freeze
    STEP_ALLOWED_OPTIONS = %i[
      on_success
      on_failure
      finish_him
      if
      unless
      action
    ].freeze
    ALLOWED_STEP_FINISH_HIM_VALUES = [
      :on_success,
      :on_failure
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
    STEP_METHOD_NOT_DEFINED = "step :%s"

    # *************************************************
    # FAIL
    # *************************************************

    FAIL_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
      %s
      Next options are not allowed for "fail":
      %s

      Details:
      %s

      Allowed options are:
      %s

      Please read the manual about allowed options here:
      %s
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
    FAIL_OPTIONS_IS_NOT_ALLOWED = '"%s" option(s) is not allowed for "fail"'
    FAIL_METHOD_NOT_DEFINED = "fail :%s"

    # *************************************************
    # PASS
    # *************************************************

    PASS_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
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
    PASS_ALLOWED_OPTIONS =  %i[
      finish_him
      if
      unless
    ]
    PASS_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
      finish_him: true
      if: <instance method symbol>
      unless: <instance method symbol>
    ALLOWED_OPTIONS
    PASS_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      if
      unless
    ]
    PASS_MANUAL_URL = 'https://stub.pass.manual.url'
    PASS_OPTIONS_IS_NOT_ALLOWED = '"%s" option(s) is not allowed for "pass"'
    PASS_METHOD_NOT_DEFINED = "pass :%s"

    # *************************************************
    # STRATEGY
    # *************************************************

    STRATEGY_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
      %s
      Next options are not allowed for "strg":
      %s

      Details:
      %s

      Allowed options are:
      %s

      Please read the manual about allowed options here:
      %s
      %s
    ERROR_MESSAGE
    STRATEGY_REQUIRED_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
      %s
      Details:
      %s

      Allowed options are:
      %s

      Please read the manual about allowed options here:
      %s
      %s
    ERROR_MESSAGE
    STRATEGY_ALLOWED_OPTIONS =  %i[
      ctx_key
      hash_case
      if
      unless
    ]
    STRATEGY_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      if
      unless
    ]
    STRATEGY_REQUIRED_KEYS = %i[
      ctx_key
    ]

    # Possible strategy options
    # on_success: <step name OR :finish_him>
    # on_failure: <step name OR :finish_him>
    # finish_him: :on_success
    # finish_him: :on_failure
    STRATEGY_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
      ctx_key: <ctx key with strategy name to be used for strategy mapping> - required
      if: <instance method symbol>
      unless: <instance method symbol>
    ALLOWED_OPTIONS
    STRATEGY_OPTIONS_IS_NOT_ALLOWED = '"%s" option(s) is not allowed for "strg"'
    STRATEGY_MANUAL_URL = 'https://stub.strategy.manual.url'
    STRATEGY_OPTIONS_IS_REQUIRED = 'Next option(s) "%s" are required for "strg"'


    # *************************************************
    # SQUAD
    # *************************************************

    SQUAD_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
      %s
      Next options are not allowed for "squad":
      %s
    ERROR_MESSAGE

    SQUAD_MANUAL_URL = 'https://stub.squad.manual.url'

    # *************************************************
    # WRAP
    # *************************************************
    WRAP_VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
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

    WRAP_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      on_success
      on_failure
      if
      unless
    ]
    WRAP_CHECK_STEP_PRESENCE = %i[
      on_success
      on_failure
    ].freeze
    WRAP_ALLOWED_OPTIONS = %i[
      on_success
      on_failure
      finish_him
      if
      unless
      klass
      method
      wrap_block
    ].freeze
    ALLOWED_WRAP_FINISH_HIM_VALUES = [
      :on_success,
      :on_failure
    ].freeze

    WRAP_ALLOWED_OPTIONS_MESSAGE = <<~ALLOWED_OPTIONS
      on_success: <step name OR :finish_him>
      on_failure: <step name OR :finish_him>
      finish_him: :on_success
      finish_him: :on_failure
      if: <instance method symbol>
      unless: <instance method symbol>
      klass: <class which implements wrap method, "method" option should be present>
      method: <method name for wrapping, "klass" option should be present>
    ALLOWED_OPTIONS
    WRAP_MANUAL_URL = 'https://stub.wrap.manual.url'
    EXTRA_WRAP_KEYS_ARE_NOT_ALLOWED = 'Please check if wrap option is allowed'
    KLASS_AND_METHOD_PRESENCE = '"klass" options should be passed along with "method" option'
    METHOD_IS_NOT_DEFINED_FOR_KLASS = 'Method "%s" is not defined for "%s" class'
    WRAP_NAME_IS_EMPTY = 'wrap name is empty'
    SPECIFY_WRAP_NAME = 'Please specify name for "wrap"'

    # *************************************************
    # COMMON
    # *************************************************

    WRONG_FINISH_HIM_VALUE = '"finish_him" does not allow "%s" value'
    METHOD_IS_NOT_DEFINED = 'Method "%s" is not defined'
    STEP_IS_NOT_DEFINED = 'Step "%s" is not defined'
  end
end
