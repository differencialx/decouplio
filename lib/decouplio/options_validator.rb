require_relative 'step'
require_relative 'errors/options_validation_error'

module Decouplio
  class OptionsValidator
    def self.call(name:, type:, options:)
      new(name: name, type: type, options: options).call
    end

    def initialize(name:, type:, options:)
      @type = type
      @options = options
      @name = name
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
      # extra_keys = @options.keys - STEP_ALLOWED_OPTIONS

      # if extra_keys.size > 0
      #   raise_validation_error(
      #     compose_message(
      #       STEP_VALIDATION_ERROR_MESSAGE,
      #       [
      #         @options.slice(extra_keys).to_s,
      #         EXTRA_STEP_KEYS_ARE_NOT_ALLOWED,
      #         STEP_ALLOWED_OPTIONS_MESSAGE,
      #         STEP_MANUAL_URL
      #       ]
      #     )
      #   )
      # else
      # end
    end

    def validate_fail
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
  end
end
