# frozen_string_literal: true

module Decouplio
  class StepValidator
    def self.call(stp, steps)
      case stp
      when Decouplio::Steps::Step
        validate_name(stp.name)
        validate_step(stp, steps)
      when Decouplio::Steps::InnerActionStep, Decouplio::Steps::ServiceAsStep
        validate_step(stp, steps)
      when Decouplio::Steps::Fail
        validate_name(stp.name)
        validate_fail(stp, steps)
      when Decouplio::Steps::InnerActionFail, Decouplio::Steps::ServiceAsFail
        validate_fail(stp, steps)
      when Decouplio::Steps::Pass
        validate_name(stp.name)
        validate_pass(stp, steps)
      when Decouplio::Steps::ServiceAsPass, Decouplio::Steps::InnerActionPass
        validate_pass(stp, steps)
      when Decouplio::Steps::Wrap,
           Decouplio::Steps::WrapWithClassMethod
        validate_name(stp.name)
        validate_finish_him(stp, Decouplio::Errors::WrapFinishHimError)
        validate_contraversal_key(stp, Decouplio::Errors::WrapControversialKeysError)
        validate_on_s(stp, steps, Decouplio::Errors::StepIsNotDefinedForWrapError)
        validate_on_f(stp, steps, Decouplio::Errors::StepIsNotDefinedForWrapError)
        validate_on_e(stp, steps, Decouplio::Errors::StepIsNotDefinedForWrapError)
      when Decouplio::Steps::OctoByKey,
           Decouplio::Steps::OctoByMethod
        validate_name(stp.name)
      when Decouplio::Steps::ResqPass,
           Decouplio::Steps::ResqFail
        validate_name(stp.name)
        validate_name(stp.handler_method)
        call(stp.step_to_resq, steps)
      when Decouplio::Steps::ResqWithMappingPass,
           Decouplio::Steps::ResqWithMappingFail
        validate_name(stp.name)
        stp.mappings.each do |class_to_handle, handler_method_name|
          validate_symbol(handler_method_name)
          validate_name(handler_method_name)
          validate_class(class_to_handle, handler_method_name)
          validate_exception_inheritance(class_to_handle)
        end
        call(stp.step_to_resq, steps)
      when Decouplio::Steps::IfConditionPass,
           Decouplio::Steps::IfConditionFail,
           Decouplio::Steps::UnlessConditionPass,
           Decouplio::Steps::UnlessConditionFail
        validate_name(stp.condition_method)
      end
    end

    def self.validate_step(stp, steps)
      validate_finish_him(stp, Decouplio::Errors::StepFinishHimError)
      validate_contraversal_key(stp, Decouplio::Errors::StepControversialKeysError)
      validate_on_s(stp, steps, Decouplio::Errors::StepIsNotDefinedForStepError)
      validate_on_f(stp, steps, Decouplio::Errors::StepIsNotDefinedForStepError)
      validate_on_e(stp, steps, Decouplio::Errors::StepIsNotDefinedForStepError)
    end

    def self.validate_fail(stp, steps)
      validate_finish_him_for_fail(stp, Decouplio::Errors::FailFinishHimError)
      validate_contraversal_key(stp, Decouplio::Errors::FailControversialKeysError)
      validate_on_s(stp, steps, Decouplio::Errors::StepIsNotDefinedForFailError)
      validate_on_f(stp, steps, Decouplio::Errors::StepIsNotDefinedForFailError)
      validate_on_e(stp, steps, Decouplio::Errors::StepIsNotDefinedForFailError)
    end

    def self.validate_pass(stp, steps)
      validate_finish_him_for_pass(stp, Decouplio::Errors::PassFinishHimError)
      validate_contraversal_key(stp, Decouplio::Errors::StepControversialKeysError)
      validate_on_s(stp, steps, Decouplio::Errors::StepIsNotDefinedForPassError)
      validate_on_f(stp, steps, Decouplio::Errors::StepIsNotDefinedForPassError)
      validate_on_e(stp, steps, Decouplio::Errors::StepIsNotDefinedForPassError)
    end

    def self.validate_class(class_to_handle, handler_method_name)
      return if class_to_handle.is_a?(Class)

      raise Decouplio::Errors::ResqErrorClassError.new(
        errored_option: class_to_handle,
        details: handler_method_name
      )
    end

    def self.validate_exception_inheritance(class_to_handle)
      return if class_to_handle < Exception

      raise Decouplio::Errors::InvalidErrorClassError.new(
        errored_option: class_to_handle,
        details: class_to_handle
      )
    end

    def self.validate_symbol(stp_name)
      return if stp_name.is_a?(Symbol)

      raise Decouplio::Errors::ResqHandlerMethodError.new(
        errored_option: stp_name
      )
    end

    def self.validate_name(stp_name)
      if Decouplio::Const::ReservedMethods::NAMES.include?(stp_name)
        raise Decouplio::Errors::StepNameError.new(
          errored_option: stp_name
        )
      end

      unless stp_name.is_a?(Symbol) ||
             (
               (stp_name.is_a?(Class) && stp_name < Decouplio::Action) ||
               (stp_name.is_a?(Class) && stp.respond_to?(:call))
             )
        raise Decouplio::Errors::StepDefinitionError.new(
          errored_option: stp_name
        )
      end
    end

    def self.validate_on_s(stp, steps, exception_class)
      return if [nil, :finish_him, :PASS, :FAIL].include?(stp.on_success)
      return if steps.any? { |s| s.name == stp.on_success }

      raise exception_class.new(
        errored_option: { on_success: stp.on_success },
        details: stp.on_success
      )
    end

    def self.validate_on_f(stp, steps, exception_class)
      return if [nil, :finish_him, :PASS, :FAIL].include?(stp.on_failure)
      return if steps.any? { |s| s.name == stp.on_failure }

      raise exception_class.new(
        errored_option: { on_failure: stp.on_failure },
        details: stp.on_failure
      )
    end

    def self.validate_on_e(stp, steps, exception_class)
      return if [nil, :finish_him, :PASS, :FAIL].include?(stp.on_error)
      return if steps.any? { |s| s.name == stp.on_error }

      raise exception_class.new(
        errored_option: { on_error: stp.on_error },
        details: stp.on_error
      )
    end

    def self.validate_finish_him(stp, exception_class)
      return if [nil, :on_success, :on_failure, :on_error].include?(stp.finish_him)

      raise exception_class.new(
        errored_option: { finish_him: stp.finish_him },
        details: stp.finish_him
      )
    end

    def self.validate_finish_him_for_fail(stp, exception_class)
      return if [nil, true, :on_success, :on_failure, :on_error].include?(stp.finish_him)

      raise exception_class.new(
        errored_option: { finish_him: stp.finish_him },
        details: stp.finish_him
      )
    end

    def self.validate_finish_him_for_pass(stp, exception_class)
      return if [nil, true, :on_error].include?(stp.finish_him)

      raise exception_class.new(
        errored_option: { finish_him: stp.finish_him },
        details: stp.finish_him
      )
    end

    def self.validate_contraversal_key(stp, exception_class)
      if stp.on_success && stp.finish_him
        raise exception_class.new(
          errored_option: { on_success: stp.on_success, finish_him: stp.finish_him },
          details: %i[on_success finish_him]
        )
      elsif stp.on_failure && stp.finish_him
        raise exception_class.new(
          errored_option: { on_failure: stp.on_failure, finish_him: stp.finish_him },
          details: %i[on_failure finish_him]
        )
      elsif stp.on_error && stp.finish_him
        raise exception_class.new(
          errored_option: { on_error: stp.on_error, finish_him: stp.finish_him },
          details: %i[on_error finish_him]
        )
      end
    end
  end
end
