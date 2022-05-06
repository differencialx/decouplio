# frozen_string_literal: true

require_relative 'const/types'
require_relative 'errors/action_class_error'
require_relative 'errors/extra_key_for_step_error'
require_relative 'errors/extra_key_for_fail_error'
require_relative 'errors/extra_key_for_octo_error'
require_relative 'errors/extra_key_for_pass_error'
require_relative 'errors/extra_key_for_resq_error'
require_relative 'errors/extra_key_for_wrap_error'
require_relative 'errors/fail_finish_him_error'
require_relative 'errors/invalid_error_class_error'
require_relative 'errors/invalid_wrap_name_error'
require_relative 'errors/pass_finish_him_error'
require_relative 'errors/required_options_is_missing_for_octo_error'
require_relative 'errors/resq_error_class_error'
require_relative 'errors/resq_handler_method_error'
require_relative 'errors/step_finish_him_error'
require_relative 'errors/step_is_not_defined_error'
require_relative 'errors/step_is_not_defined_for_wrap_error'
require_relative 'errors/wrap_finish_him_error'
require_relative 'errors/wrap_klass_method_error'
require_relative 'errors/step_controversial_keys_error'
require_relative 'errors/fail_controversial_keys_error'
require_relative 'errors/pass_controversial_keys_error'
require_relative 'errors/octo_controversial_keys_error'
require_relative 'errors/wrap_controversial_keys_error'

module Decouplio
  class OptionsValidator
    def initialize(flow:, palps:, next_steps:)
      @flow = flow
      @palps = palps
      @step_names = extract_step_names(flow: @flow.merge(next_steps || {}))
    end

    def call
      @flow.each do |_step_id, options|
        validate(options: options)
      end
    end

    private

    def validate(options:)
      filtered_options = options.reject { |key, _val| OPTIONS_TO_FILTER.include?(key) }
      case options[:type]
      when Decouplio::Const::Types::STEP_TYPE
        validate_step(options: filtered_options)
      when Decouplio::Const::Types::FAIL_TYPE
        validate_fail(options: filtered_options)
      when Decouplio::Const::Types::PASS_TYPE
        validate_pass(options: filtered_options)
      when Decouplio::Const::Types::OCTO_TYPE
        validate_octo(options: filtered_options)
      when Decouplio::Const::Types::WRAP_TYPE
        validate_wrap(options: filtered_options, name: options[:name])
      when Decouplio::Const::Types::ACTION_TYPE_STEP
        validate_action(action_class: options[:action], type: Decouplio::Const::Types::STEP_TYPE)
        validate_step(options: filtered_options)
      when Decouplio::Const::Types::ACTION_TYPE_FAIL
        validate_action(action_class: options[:action], type: Decouplio::Const::Types::FAIL_TYPE)
        validate_fail(options: filtered_options)
      when Decouplio::Const::Types::ACTION_TYPE_PASS
        validate_action(action_class: options[:action], type: Decouplio::Const::Types::PASS_TYPE)
        validate_pass(options: filtered_options)
      when Decouplio::Const::Types::RESQ_TYPE_STEP,
           Decouplio::Const::Types::RESQ_TYPE_FAIL,
           Decouplio::Const::Types::RESQ_TYPE_PASS
        validate(options: options[:step_to_resq])
        validate_resq(options: filtered_options)
      end
    end

    def validate_action(action_class:, type:)
      return if action_class.is_a?(Class) && action_class <= Decouplio::Action

      raise Decouplio::Errors::ActionClassError.new(
        step_type: type,
        errored_option: "action: #{action_class}"
      )
    end

    def validate_step(options:)
      check_step_presence(options: options)
      check_step_controversial_keys(options: options)
      check_step_extra_keys(options: options)
      check_step_finish_him(options: options)
      # TODO: check reccursion call for on_success and on_failure
    end

    def validate_fail(options:)
      check_fail_controversial_keys(options: options)
      check_fail_extra_keys(options: options)
      check_fail_finish_him(options: options)
    end

    def validate_pass(options:)
      check_pass_controversial_keys(options: options)
      check_pass_extra_keys(options: options)
      check_pass_finish_him(options: options)
    end

    def validate_octo(options:)
      check_octo_controversial_keys(options: options)
      check_octo_required_keys(options: options)
      check_octo_extra_keys(options: options)
    end

    def validate_wrap(options:, name:)
      check_wrap_name(name: name)
      check_wrap_controversial_keys(options: options)
      check_wrap_step_presence(options: options)
      check_wrap_extra_keys(options: options)
      check_wrap_finish_him(options: options)
      check_wrap_klass_method_presence(options: options)
    end

    def validate_resq(options:)
      check_resq_extra_keys(options: options)
      check_resq_handler_method_is_a_symbol(options: options)
      check_resq_error_classes(options: options)
      check_resq_exception_classes_inheritance(options: options)
    end

    def check_step_presence(options:)
      options.slice(*STEP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure].include?(option_key) && option_value == :finish_him

        next if @step_names.keys.include?(option_value)

        raise Decouplio::Errors::StepIsNotDefinedError.new(
          errored_option: options.slice(option_key).to_s,
          details: option_value
        )
      end
    end

    def check_wrap_step_presence(options:)
      options.slice(*WRAP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure].include?(option_key) && option_value == :finish_him

        next if @step_names.keys.include?(option_value)

        raise Decouplio::Errors::StepIsNotDefinedForWrapError.new(
          errored_option: options.slice(option_key).to_s,
          details: option_value
        )
      end
    end

    def check_step_extra_keys(options:)
      extra_keys = options.keys - STEP_ALLOWED_OPTIONS

      if extra_keys.size.positive?
        raise Decouplio::Errors::ExtraKeyForStepError.new(
          errored_option: options.slice(*extra_keys).to_s
        )
      end
    end

    def check_step_controversial_keys(options:)
      on_success_on_failure = options.slice(:on_success, :on_failure)
      finish_him = options.slice(:finish_him)
      if_condition = options.slice(:if)
      unless_condition = options.slice(:unless)

      if !on_success_on_failure.empty? && !finish_him.empty?
        raise Decouplio::Errors::StepControversialKeysError.new(
          errored_option: on_success_on_failure.merge(finish_him).to_s,
          details: [on_success_on_failure.keys.join(', '), :finish_him]
        )
      elsif !if_condition.empty? && !unless_condition.empty?
        raise Decouplio::Errors::StepControversialKeysError.new(
          errored_option: if_condition.merge(unless_condition).to_s,
          details: %i[if unless]
        )
      end
    end

    def check_fail_extra_keys(options:)
      extra_keys = options.keys - FAIL_ALLOWED_OPTIONS

      return if extra_keys.size.zero?

      raise Decouplio::Errors::ExtraKeyForFailError.new(
        errored_option: options.slice(*extra_keys).to_s,
        details: extra_keys.join(', ')
      )
    end

    def check_fail_controversial_keys(options:)
      on_success_on_failure = options.slice(:on_success, :on_failure)
      finish_him = options.slice(:finish_him)
      if_condition = options.slice(:if)
      unless_condition = options.slice(:unless)

      if !on_success_on_failure.empty? && !finish_him.empty?
        raise Decouplio::Errors::FailControversialKeysError.new(
          errored_option: on_success_on_failure.merge(finish_him).to_s,
          details: [on_success_on_failure.keys.join(', '), :finish_him]
        )
      elsif !if_condition.empty? && !unless_condition.empty?
        raise Decouplio::Errors::FailControversialKeysError.new(
          errored_option: if_condition.merge(unless_condition).to_s,
          details: %i[if unless]
        )
      end
    end

    def check_pass_extra_keys(options:)
      extra_keys = options.keys - PASS_ALLOWED_OPTIONS

      if extra_keys.size.positive?
        raise Decouplio::Errors::ExtraKeyForPassError.new(
          errored_option: options.slice(*extra_keys).to_s,
          details: extra_keys.join(', ')
        )
      end
    end

    def check_pass_controversial_keys(options:)
      if_condition = options.slice(:if)
      unless_condition = options.slice(:unless)

      if !if_condition.empty? && !unless_condition.empty?
        raise Decouplio::Errors::PassControversialKeysError.new(
          errored_option: if_condition.merge(unless_condition).to_s,
          details: %i[if unless]
        )
      end
    end

    def check_octo_extra_keys(options:)
      extra_keys = options.keys - OCTO_ALLOWED_OPTIONS

      if extra_keys.size.positive?
        raise Decouplio::Errors::ExtraKeyForOctoError.new(
          errored_option: options.slice(*extra_keys).to_s,
          details: extra_keys.join(', ')
        )
      end
    end

    def check_octo_controversial_keys(options:)
      if_condition = options.slice(:if)
      unless_condition = options.slice(:unless)

      if !if_condition.empty? && !unless_condition.empty?
        raise Decouplio::Errors::OctoControversialKeysError.new(
          errored_option: if_condition.merge(unless_condition).to_s,
          details: %i[if unless]
        )
      end
    end

    def check_wrap_extra_keys(options:)
      extra_keys = options.keys - WRAP_ALLOWED_OPTIONS

      if extra_keys.size.positive?
        raise Decouplio::Errors::ExtraKeyForWrapError.new(
          errored_option: options.slice(*extra_keys).to_s
        )
      end
    end

    def check_wrap_controversial_keys(options:)
      on_success_on_failure = options.slice(:on_success, :on_failure)
      finish_him = options.slice(:finish_him)
      if_condition = options.slice(:if)
      unless_condition = options.slice(:unless)

      if !on_success_on_failure.empty? && !finish_him.empty?
        raise Decouplio::Errors::WrapControversialKeysError.new(
          errored_option: on_success_on_failure.merge(finish_him).to_s,
          details: [on_success_on_failure.keys.join(', '), :finish_him]
        )
      elsif !if_condition.empty? && !unless_condition.empty?
        raise Decouplio::Errors::WrapControversialKeysError.new(
          errored_option: if_condition.merge(unless_condition).to_s,
          details: %i[if unless]
        )
      end
    end

    def check_octo_required_keys(options:)
      return if (OCTO_REQUIRED_KEYS - options.keys).size.zero?

      raise Decouplio::Errors::RequiredOptionsIsMissingForOctoError.new(
        details: OCTO_REQUIRED_KEYS.join(', ')
      )
    end

    def check_step_finish_him(options:)
      finish_him_value = options.dig(:finish_him)

      return unless finish_him_value && options.key?(:finish_him)

      unless ALLOWED_STEP_FINISH_HIM_VALUES.include?(finish_him_value)
        raise Decouplio::Errors::StepFinishHimError.new(
          errored_option: options.slice(:finish_him).to_s,
          details: finish_him_value
        )
      end
    end

    def check_fail_finish_him(options:)
      finish_him_value = options.dig(:finish_him)

      return unless options.key?(:finish_him)

      return if ALLOWED_FAIL_FINISH_HIM_VALUES.include?(finish_him_value)

      raise Decouplio::Errors::FailFinishHimError.new(
        errored_option: options.slice(:finish_him).to_s,
        details: finish_him_value
      )
    end

    def check_pass_finish_him(options:)
      finish_him_value = options.dig(:finish_him)

      return unless finish_him_value && options.key?(:finish_him)

      unless ALLOWED_PASS_FINISH_HIM_VALUES.include?(finish_him_value)
        raise Decouplio::Errors::PassFinishHimError.new(
          errored_option: options.slice(:finish_him).to_s,
          details: finish_him_value
        )
      end
    end

    def check_wrap_finish_him(options:)
      finish_him_value = options.dig(:finish_him)

      return unless finish_him_value && options.key?(:finish_him)

      unless ALLOWED_WRAP_FINISH_HIM_VALUES.include?(finish_him_value)
        raise Decouplio::Errors::WrapFinishHimError.new(
          errored_option: options.slice(:finish_him).to_s,
          details: finish_him_value
        )
      end
    end

    def check_wrap_klass_method_presence(options:)
      klass_method_options = options.slice(:klass, :method)
      klass_method_options_size = klass_method_options.size

      return if klass_method_options_size.zero? || klass_method_options_size == 2

      raise Decouplio::Errors::WrapKlassMethodError.new(
        errored_option: klass_method_options.to_s
      )
    end

    def check_wrap_name(name:)
      return if name.is_a?(Symbol)

      raise Decouplio::Errors::InvalidWrapNameError
    end

    def check_resq_extra_keys(options:)
      extra_options = options[:handler_hash].values.select do |option|
        RESQ_NOT_ALLOWED_OPTIONS.include?(option)
      end

      return if extra_options.empty?

      raise Decouplio::Errors::ExtraKeyForResqError.new(
        errored_option: extra_options.join(', ').to_s,
        details: extra_options.join(', ').to_s
      )
    end

    def check_resq_handler_method_is_a_symbol(options:)
      options[:handler_hash].values.uniq.each do |handler_method|
        next if handler_method.is_a?(Symbol)

        raise Decouplio::Errors::ResqHandlerMethodError.new(
          errored_option: handler_method.to_s
        )
      end
    end

    def check_resq_error_classes(options:)
      options[:handler_hash].each_key do |error_class|
        next if error_class.is_a?(Class)

        raise Decouplio::Errors::ResqErrorClassError.new(
          errored_option: error_class.to_s,
          details: options[:handler_hash][error_class].to_s
        )
      end
    end

    def check_resq_exception_classes_inheritance(options:)
      options[:handler_hash].each_key do |klass|
        next if klass < Exception

        raise Decouplio::Errors::InvalidErrorClassError.new(
          errored_option: klass.to_s,
          details: klass.to_s
        )
      end
    end

    def extract_step_names(flow:)
      flow.to_h do |_step_id, stp|
        [stp[:name], stp[:type]]
      end
    end

    OPTIONS_TO_FILTER = %i[
      step_id
      flow
      name
      type
      hash_case
      wrap_flow
      step_to_resq
    ].freeze

    # *************************************************
    # STEP
    # *************************************************

    STEP_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      on_success
      on_failure
      if
      unless
    ].freeze
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
    ALLOWED_STEP_FINISH_HIM_VALUES = %i[
      on_success
      on_failure
    ].freeze

    # *************************************************
    # FAIL
    # *************************************************

    FAIL_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      if
      unless
    ].freeze
    FAIL_ALLOWED_OPTIONS = %i[
      on_success
      on_failure
      finish_him
      if
      unless
      action
    ].freeze
    ALLOWED_FAIL_FINISH_HIM_VALUES = [true, :on_success, :on_failure].freeze

    # *************************************************
    # PASS
    # *************************************************

    PASS_ALLOWED_OPTIONS = %i[
      finish_him
      if
      unless
      action
    ].freeze

    PASS_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      if
      unless
    ].freeze
    ALLOWED_PASS_FINISH_HIM_VALUES = [true].freeze

    # *************************************************
    # OCTO
    # *************************************************

    OCTO_ALLOWED_OPTIONS = %i[
      ctx_key
      if
      unless
    ].freeze
    OCTO_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      if
      unless
    ].freeze
    OCTO_REQUIRED_KEYS = %i[
      ctx_key
    ].freeze

    # *************************************************
    # WRAP
    # *************************************************

    WRAP_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      on_success
      on_failure
      if
      unless
    ].freeze
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
    ALLOWED_WRAP_FINISH_HIM_VALUES = %i[
      on_success
      on_failure
    ].freeze

    # *************************************************
    # RESQ
    # *************************************************

    RESQ_NOT_ALLOWED_OPTIONS = %i[
      on_success
      on_failure
      finish_him
      if
      unless
      klass
      method
    ].freeze
  end
end
