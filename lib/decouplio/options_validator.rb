# frozen_string_literal: true

require_relative 'const/types'
require_relative 'const/reserved_methods'
require_relative 'errors/action_class_error'
require_relative 'errors/extra_key_for_step_error'
require_relative 'errors/extra_key_for_fail_error'
require_relative 'errors/extra_key_for_octo_error'
require_relative 'errors/extra_key_for_pass_error'
require_relative 'errors/extra_key_for_resq_error'
require_relative 'errors/extra_key_for_wrap_error'
require_relative 'errors/fail_finish_him_error'
require_relative 'errors/doby_finish_him_error'
require_relative 'errors/aide_finish_him_error'
require_relative 'errors/invalid_error_class_error'
require_relative 'errors/invalid_wrap_name_error'
require_relative 'errors/pass_finish_him_error'
require_relative 'errors/required_options_is_missing_for_octo_error'
require_relative 'errors/resq_error_class_error'
require_relative 'errors/resq_handler_method_error'
require_relative 'errors/step_finish_him_error'
require_relative 'errors/step_is_not_defined_for_step_error'
require_relative 'errors/step_is_not_defined_for_fail_error'
require_relative 'errors/step_is_not_defined_for_pass_error'
require_relative 'errors/step_is_not_defined_for_wrap_error'
require_relative 'errors/step_is_not_defined_for_aide_error'
require_relative 'errors/step_is_not_defined_for_doby_error'
require_relative 'errors/wrap_finish_him_error'
require_relative 'errors/wrap_klass_method_error'
require_relative 'errors/step_controversial_keys_error'
require_relative 'errors/doby_controversial_keys_error'
require_relative 'errors/aide_controversial_keys_error'
require_relative 'errors/fail_controversial_keys_error'
require_relative 'errors/pass_controversial_keys_error'
require_relative 'errors/octo_controversial_keys_error'
require_relative 'errors/wrap_controversial_keys_error'
require_relative 'errors/palp_is_not_defined_error'
require_relative 'errors/error_store_error'
require_relative 'errors/step_name_error'

module Decouplio
  class OptionsValidator
    def initialize(flow:, palps:, next_steps:, action_class:)
      @flow = flow
      @palps = palps
      @next_steps = next_steps
      @action_class = action_class
    end

    def call
      @flow.each_with_index do |(_step_id, options), index|
        step_names = extract_step_names(flow: @flow.to_a[index..].to_h.merge(@next_steps || {}))

        validate(options: options, step_names: step_names)
      end
    end

    private

    def validate(options:, step_names:)
      filtered_options = options.reject { |key, _val| OPTIONS_TO_FILTER.include?(key) }

      validate_name(name: options[:name])
      @palps.each_key do |palp_name|
        validate_name(name: palp_name)
      end

      case options[:type]
      when Decouplio::Const::Types::STEP_TYPE
        validate_step(options: filtered_options, step_names: step_names)
      when Decouplio::Const::Types::FAIL_TYPE
        validate_fail(options: filtered_options, step_names: step_names)
      when Decouplio::Const::Types::PASS_TYPE
        validate_pass(options: filtered_options, step_names: step_names)
      when Decouplio::Const::Types::OCTO_TYPE
        validate_octo(options: filtered_options, hash_case: options[:hash_case])
      when Decouplio::Const::Types::WRAP_TYPE
        validate_wrap(options: filtered_options, name: options[:name], step_names: step_names)
      when Decouplio::Const::Types::ACTION_TYPE_STEP
        validate_action(action_class: options[:action], type: Decouplio::Const::Types::STEP_TYPE)
        validate_error_store(parent_action_class: @action_class, child_action_class: options[:action])
        validate_step(options: filtered_options, step_names: step_names)
      when Decouplio::Const::Types::ACTION_TYPE_FAIL
        validate_action(action_class: options[:action], type: Decouplio::Const::Types::FAIL_TYPE)
        validate_error_store(parent_action_class: @action_class, child_action_class: options[:action])
        validate_fail(options: filtered_options, step_names: step_names)
      when Decouplio::Const::Types::ACTION_TYPE_PASS
        validate_action(action_class: options[:action], type: Decouplio::Const::Types::PASS_TYPE)
        validate_error_store(parent_action_class: @action_class, child_action_class: options[:action])
        validate_pass(options: filtered_options, step_names: step_names)
      when Decouplio::Const::Types::RESQ_TYPE_STEP,
           Decouplio::Const::Types::RESQ_TYPE_FAIL,
           Decouplio::Const::Types::RESQ_TYPE_PASS
        validate(options: options[:step_to_resq], step_names: step_names)
        validate_resq(options: filtered_options)
      when Decouplio::Const::Types::DOBY_TYPE
        validate_doby(options: filtered_options, step_names: step_names)
      when Decouplio::Const::Types::AIDE_TYPE
        validate_aide(options: filtered_options, step_names: step_names)
      end
    end

    def validate_action(action_class:, type:)
      return if action_class.is_a?(Class) && action_class <= Decouplio::Action

      raise Decouplio::Errors::ActionClassError.new(
        step_type: type,
        errored_option: "action: #{action_class}"
      )
    end

    def validate_step(options:, step_names:)
      check_step_presence_for_step(options: options, step_names: step_names)
      check_step_controversial_keys(options: options)
      check_step_extra_keys(options: options)
      check_step_finish_him(options: options)
    end

    def validate_fail(options:, step_names:)
      check_step_presence_for_fail(options: options, step_names: step_names)
      check_fail_controversial_keys(options: options)
      check_fail_extra_keys(options: options)
      check_fail_finish_him(options: options)
    end

    def validate_pass(options:, step_names:)
      check_step_presence_for_pass(options: options, step_names: step_names)
      check_pass_extra_keys(options: options)
      check_pass_finish_him(options: options)
    end

    def validate_octo(options:, hash_case:)
      check_octo_required_keys(options: options)
      check_octo_extra_keys(options: options)
      check_octo_palps(hash_case: hash_case)
    end

    def validate_wrap(options:, name:, step_names:)
      check_wrap_name(name: name)
      check_wrap_controversial_keys(options: options)
      check_step_presence_for_wrap(options: options, step_names: step_names)
      check_wrap_extra_keys(options: options)
      check_wrap_finish_him(options: options)
      check_wrap_klass_method_presence(options: options)
    end

    def validate_resq(options:)
      options[:handler_hash].each_value do |error_handler_name|
        validate_name(name: error_handler_name)
      end
      check_resq_extra_keys(options: options)
      check_resq_handler_method_is_a_symbol(options: options)
      check_resq_error_classes(options: options)
      check_resq_exception_classes_inheritance(options: options)
    end

    def validate_doby(options:, step_names:)
      check_step_presence_for_doby(options: options, step_names: step_names)
      check_doby_controversial_keys(options: options)
      check_doby_finish_him(options: options)
    end

    def validate_aide(options:, step_names:)
      check_step_presence_for_aide(options: options, step_names: step_names)
      check_aide_controversial_keys(options: options)
      check_aide_finish_him(options: options)
    end

    def validate_name(name:)
      return unless Decouplio::Const::ReservedMethods::NAMES.include?(name)

      raise Decouplio::Errors::StepNameError.new(
        errored_option: name
      )
    end

    def check_step_presence_for_step(options:, step_names:)
      options.slice(*STEP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure on_error].include?(option_key) &&
                STEP_ALLOWED_ON_S_ON_F_VALUES.include?(option_value)

        next if step_names.keys.include?(option_value)

        raise Decouplio::Errors::StepIsNotDefinedForStepError.new(
          errored_option: options.slice(option_key).to_s,
          details: option_value
        )
      end
    end

    def check_step_presence_for_pass(options:, step_names:)
      options.slice(*PASS_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_error].include?(option_key) &&
                STEP_ALLOWED_ON_S_ON_F_VALUES.include?(option_value)

        next if step_names.keys.include?(option_value)

        raise Decouplio::Errors::StepIsNotDefinedForPassError.new(
          errored_option: options.slice(option_key).to_s,
          details: option_value
        )
      end
    end

    def check_step_presence_for_doby(options:, step_names:)
      options.slice(*STEP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure on_error].include?(option_key) &&
                STEP_ALLOWED_ON_S_ON_F_VALUES.include?(option_value)

        next if step_names.keys.include?(option_value)

        raise Decouplio::Errors::StepIsNotDefinedForDobyError.new(
          errored_option: options.slice(option_key).to_s,
          details: option_value
        )
      end
    end

    def check_step_presence_for_aide(options:, step_names:)
      options.slice(*STEP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure on_error].include?(option_key) &&
                STEP_ALLOWED_ON_S_ON_F_VALUES.include?(option_value)

        next if step_names.keys.include?(option_value)

        raise Decouplio::Errors::StepIsNotDefinedForAideError.new(
          errored_option: options.slice(option_key).to_s,
          details: option_value
        )
      end
    end

    def check_step_presence_for_fail(options:, step_names:)
      options.slice(*STEP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure on_error].include?(option_key) &&
                STEP_ALLOWED_ON_S_ON_F_VALUES.include?(option_value)

        next if step_names.keys.include?(option_value)

        raise Decouplio::Errors::StepIsNotDefinedForFailError.new(
          errored_option: options.slice(option_key).to_s,
          details: option_value
        )
      end
    end

    def check_step_presence_for_wrap(options:, step_names:)
      options.slice(*WRAP_CHECK_STEP_PRESENCE).each do |option_key, option_value|
        next if %i[on_success on_failure on_error].include?(option_key) &&
                STEP_ALLOWED_ON_S_ON_F_VALUES.include?(option_value)

        next if step_names.keys.include?(option_value)

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

      if !on_success_on_failure.empty? && !finish_him.empty?
        raise Decouplio::Errors::StepControversialKeysError.new(
          errored_option: on_success_on_failure.merge(finish_him).to_s,
          details: [on_success_on_failure.keys.join(', '), :finish_him]
        )
      end
    end

    def check_doby_controversial_keys(options:)
      on_success_on_failure = options.slice(:on_success, :on_failure)
      finish_him = options.slice(:finish_him)

      if !on_success_on_failure.empty? && !finish_him.empty?
        raise Decouplio::Errors::DobyControversialKeysError.new(
          errored_option: on_success_on_failure.merge(finish_him).to_s,
          details: [on_success_on_failure.keys.join(', '), :finish_him]
        )
      end
    end

    def check_aide_controversial_keys(options:)
      on_success_on_failure = options.slice(:on_success, :on_failure)
      finish_him = options.slice(:finish_him)

      if !on_success_on_failure.empty? && !finish_him.empty?
        raise Decouplio::Errors::AideControversialKeysError.new(
          errored_option: on_success_on_failure.merge(finish_him).to_s,
          details: [on_success_on_failure.keys.join(', '), :finish_him]
        )
      end
    end

    def validate_error_store(parent_action_class:, child_action_class:)
      return if parent_action_class.error_store == child_action_class.error_store

      raise Decouplio::Errors::ErrorStoreError
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

      if !on_success_on_failure.empty? && !finish_him.empty?
        raise Decouplio::Errors::FailControversialKeysError.new(
          errored_option: on_success_on_failure.merge(finish_him).to_s,
          details: [on_success_on_failure.keys.join(', '), :finish_him]
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

    def check_octo_extra_keys(options:)
      extra_keys = options.keys - OCTO_ALLOWED_OPTIONS

      if extra_keys.size.positive?
        raise Decouplio::Errors::ExtraKeyForOctoError.new(
          errored_option: options.slice(*extra_keys).to_s,
          details: extra_keys.join(', ')
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

      if !on_success_on_failure.empty? && !finish_him.empty?
        raise Decouplio::Errors::WrapControversialKeysError.new(
          errored_option: on_success_on_failure.merge(finish_him).to_s,
          details: [on_success_on_failure.keys.join(', '), :finish_him]
        )
      end
    end

    def check_octo_palps(hash_case:)
      hash_casse_palps = hash_case.map { |_octo_key, hash| hash[:palp] }.compact
      undefined_palps = hash_casse_palps - @palps.keys

      return if undefined_palps.empty?

      errored_options = hash_case.select do |_key, val|
        undefined_palps.include?(val[:palp])
      end
      errored_options = errored_options.map do |key, val|
        "\"on :#{key}, palp: :#{val[:palp]}\""
      end

      raise Decouplio::Errors::PalpIsNotDefinedError.new(
        errored_option: errored_options,
        details: undefined_palps
      )
    end

    def check_octo_required_keys(options:)
      if (OCTO_REQUIRED_KEYS - options.keys).size.zero?
        if options.keys.sort == OCTO_REQUIRED_KEYS.sort
          raise Decouplio::Errors::OctoControversialKeysError.new(
            errored_option: options.slice(*OCTO_REQUIRED_KEYS),
            details: OCTO_REQUIRED_KEYS
          )
        end
      else
        return if options.slice(*OCTO_REQUIRED_KEYS).size == 1

        raise Decouplio::Errors::RequiredOptionsIsMissingForOctoError.new(
          details: OCTO_REQUIRED_KEYS.join(', ')
        )
      end
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

    def check_doby_finish_him(options:)
      finish_him_value = options.dig(:finish_him)

      return unless finish_him_value && options.key?(:finish_him)

      unless ALLOWED_STEP_FINISH_HIM_VALUES.include?(finish_him_value)
        raise Decouplio::Errors::DobyFinishHimError.new(
          errored_option: options.slice(:finish_him).to_s,
          details: finish_him_value
        )
      end
    end

    def check_aide_finish_him(options:)
      finish_him_value = options.dig(:finish_him)

      return unless options.key?(:finish_him)

      return if ALLOWED_FAIL_FINISH_HIM_VALUES.include?(finish_him_value)

      raise Decouplio::Errors::AideFinishHimError.new(
        errored_option: options.slice(:finish_him).to_s,
        details: finish_him_value
      )
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
      on_error
      if
      unless
    ].freeze
    STEP_CHECK_STEP_PRESENCE = %i[
      on_success
      on_failure
      on_error
    ].freeze
    STEP_ALLOWED_ON_S_ON_F_VALUES = [
      Decouplio::Const::Results::STEP_PASS,
      Decouplio::Const::Results::STEP_FAIL,
      Decouplio::Const::Results::FINISH_HIM
    ].freeze
    STEP_ALLOWED_OPTIONS = %i[
      on_success
      on_failure
      on_error
      finish_him
      if
      unless
      action
    ].freeze
    ALLOWED_STEP_FINISH_HIM_VALUES = %i[
      on_success
      on_failure
      on_error
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
      on_error
      finish_him
      if
      unless
      action
    ].freeze
    ALLOWED_FAIL_FINISH_HIM_VALUES = [true, :on_success, :on_failure, :on_error].freeze

    # *************************************************
    # PASS
    # *************************************************

    PASS_ALLOWED_OPTIONS = %i[
      finish_him
      if
      unless
      action
      on_error
    ].freeze

    PASS_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      if
      unless
    ].freeze
    PASS_CHECK_STEP_PRESENCE = %i[
      on_error
    ].freeze
    ALLOWED_PASS_FINISH_HIM_VALUES = [true, :on_error].freeze

    # *************************************************
    # OCTO
    # *************************************************

    OCTO_ALLOWED_OPTIONS = %i[
      ctx_key
      method
      if
      unless
    ].freeze
    OCTO_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      if
      unless
    ].freeze
    OCTO_REQUIRED_KEYS = %i[
      ctx_key
      method
    ].freeze

    # *************************************************
    # WRAP
    # *************************************************

    WRAP_CHECK_METHOD_EXISTENCE_OPTIONS = %i[
      on_success
      on_failure
      on_error
      if
      unless
    ].freeze
    WRAP_CHECK_STEP_PRESENCE = %i[
      on_success
      on_failure
      on_error
    ].freeze
    WRAP_ALLOWED_OPTIONS = %i[
      on_success
      on_failure
      on_error
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
      on_error
    ].freeze

    # *************************************************
    # RESQ
    # *************************************************

    RESQ_NOT_ALLOWED_OPTIONS = %i[
      on_success
      on_failure
      on_error
      finish_him
      if
      unless
      klass
      method
    ].freeze
  end
end
