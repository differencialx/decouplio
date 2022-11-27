# frozen_string_literal: true

module Decouplio
  class NewFlow
    def self.call(logic)
      logic_container_raw_data = Class.new(Decouplio::LogicDsl, &logic)

      steps = logic_container_raw_data.steps

      compose_steps(steps.delete_at(0), steps)
    end

    def self.compose_steps(stp, steps)
      return stp if stp.nil?

      Decouplio::StepValidator.call(stp, steps)

      if stp.is_a?(Decouplio::Steps::BaseOcto)
        next_success_step, success_resolver = compose_flow_direction(stp, steps, :success)
        next_failure_step, failure_resolver = compose_flow_direction(stp, steps, :failure)
        next_on_error, on_error_resolver = compose_flow_direction(stp, steps, :error)

        stp._add_next_steps([next_success_step, next_failure_step, next_on_error])
        stp._add_resolvers([success_resolver, failure_resolver, on_error_resolver])

        compose_octo(stp, steps)
      elsif Decouplio::Const::Flows::RESQ_CLASSES.include?(stp.class)
        next_success_step, success_resolver = compose_flow_direction(stp.step_to_resq, steps, :success)
        next_failure_step, failure_resolver = compose_flow_direction(stp.step_to_resq, steps, :failure)
        next_on_error, on_error_resolver = compose_flow_direction(stp.step_to_resq, steps, :error)

        stp.step_to_resq._add_next_steps([next_success_step, next_failure_step, next_on_error])
        stp.step_to_resq._add_resolvers([success_resolver, failure_resolver, on_error_resolver])

        compose_wrap(stp.step_to_resq) if stp.step_to_resq.is_a?(Decouplio::Steps::BaseWrap)

        # next_success_step, success_resolver = compose_flow_direction(stp.step_to_resq, steps, :success)
        # next_failure_step, failure_resolver = compose_flow_direction(stp.step_to_resq, steps, :failure)
        # next_on_error, on_error_resolver = compose_flow_direction(stp.step_to_resq, steps, :error)

        # stp.step_to_resq._add_next_steps([next_success_step, next_failure_step, next_on_error])
        # stp.step_to_resq._add_resolvers([success_resolver, failure_resolver, on_error_resolver])
      elsif stp.is_a?(Decouplio::Steps::BaseWrap)
        compose_wrap(stp)
        compose_step(stp, steps)
      else
        compose_step(stp, steps)
      end

      next_step_to_process = steps.delete_at(0)
      compose_steps(next_step_to_process, steps)
      stp
    end

    def self.compose_wrap(stp)
      wrap_first_step = call(stp.wrap_block)
      stp._add_wrap_first_step(wrap_first_step)
    end

    def self.compose_octo(stp, steps)
      linked_hash_case = stp.hash_case.to_h do |key, octo_step|
        if octo_step.on_success.nil?
          next_success_step = stp.on_success
          success_resolver = stp.on_success_resolver
        else
          next_success_step, success_resolver = compose_flow_direction(octo_step, steps, :success)
        end

        if octo_step.on_failure.nil?
          next_failure_step = stp.on_failure
          failure_resolver = stp.on_failure_resolver
        else
          next_failure_step, failure_resolver = compose_flow_direction(octo_step, steps, :failure)
        end

        if octo_step.on_error.nil?
          next_on_error = stp.on_error
          on_error_resolver = stp.on_error_resolver
        else
          next_on_error, on_error_resolver = compose_flow_direction(octo_step, steps, :error)
        end

        compose_wrap(octo_step)

        octo_step._add_next_steps(
          [
            next_success_step,
            next_failure_step,
            next_on_error
          ]
        )
        octo_step._add_resolvers(
          [
            success_resolver,
            failure_resolver,
            on_error_resolver
          ]
        )

        if stp.resq
          octo_resq_step = stp.resq.clone
          octo_resq_step._add_step_to_resq(octo_step)
          [key, octo_resq_step]
        else
          [key, octo_step]
        end
      end

      stp._add_octo_next_steps(linked_hash_case)
    end

    def self.compose_step(stp, steps)
      next_success_step, success_resolver = compose_flow_direction(stp, steps, :success)
      next_failure_step, failure_resolver = compose_flow_direction(stp, steps, :failure)

      stp._add_next_steps([next_success_step, next_failure_step])
      stp._add_resolvers([success_resolver, failure_resolver])
    end

    def self.compose_flow_direction(stp, steps, type)
      case stp
      when Decouplio::Steps::Step,
           Decouplio::Steps::InnerActionStep,
           Decouplio::Steps::ServiceAsStep
        compose_step_outcome("for_step_#{type}".to_sym, stp, steps)
      when Decouplio::Steps::Fail,
           Decouplio::Steps::InnerActionFail,
           Decouplio::Steps::ServiceAsFail
        compose_step_outcome("for_fail_#{type}".to_sym, stp, steps)
      when Decouplio::Steps::Pass,
           Decouplio::Steps::InnerActionPass,
           Decouplio::Steps::ServiceAsPass
        compose_step_outcome("for_pass_#{type}".to_sym, stp, steps)
      when Decouplio::Steps::IfConditionPass
        compose_condition_outcome("for_if_pass_#{type}".to_sym, stp, steps)
      when Decouplio::Steps::IfConditionFail
        compose_condition_outcome("for_if_fail_#{type}".to_sym, stp, steps)
      when Decouplio::Steps::UnlessConditionPass
        compose_condition_outcome("for_unless_pass_#{type}".to_sym, stp, steps)
      when Decouplio::Steps::UnlessConditionFail
        compose_condition_outcome("for_unless_fail_#{type}".to_sym, stp, steps)
      when Decouplio::Steps::Wrap,
           Decouplio::Steps::WrapWithClass,
           Decouplio::Steps::WrapWithClassMethod
        compose_step_outcome("for_wrap_#{type}".to_sym, stp, steps)
      when Decouplio::Steps::BaseOcto
        compose_step_outcome("for_octo_#{type}".to_sym, stp, steps)
      end
    end

    def self.compose_step_outcome(flow, stp, steps)
      case flow
      when :for_fail_success
        return [nil, false] if stp.finish_him == true
        return [nil, false] if stp.finish_him == :on_success
        return [next_failure_step(steps), false] if stp.on_success.nil?
        return [nil, false] if stp.on_success == :finish_him
        return [next_success_step(steps), true] if stp.on_success == :PASS
        return [next_failure_step(steps), false] if stp.on_success == :FAIL

        [next_step(stp.on_success, steps), false]
      when :for_fail_failure
        return [nil, false] if stp.finish_him == true
        return [nil, false] if stp.finish_him == :on_failure
        return [next_failure_step(steps), false] if stp.on_failure.nil?
        return [nil, false] if stp.on_failure == :finish_him
        return [next_success_step(steps), true] if stp.on_failure == :PASS
        return [next_failure_step(steps), false] if stp.on_failure == :FAIL

        [next_step(stp.on_failure, steps), false]
      when :for_pass_success
        return [nil, true] if stp.finish_him == true

        [next_success_step(steps), true]
      when :for_pass_failure
        [nil, nil]
      when :for_step_success, :for_wrap_success, :for_octo_success
        return [nil, true] if stp.finish_him == :on_success
        return [next_success_step(steps), true] if stp.on_success.nil?
        return [nil, true] if stp.on_success == :finish_him
        return [next_success_step(steps), true] if stp.on_success == :PASS
        return [next_failure_step(steps), false] if stp.on_success == :FAIL

        [next_step(stp.on_success, steps), true]
      when :for_step_failure, :for_wrap_failure, :for_octo_failure
        return [nil, false] if stp.finish_him == :on_failure
        return [next_failure_step(steps), false] if stp.on_failure.nil?
        return [nil, false] if stp.on_failure == :finish_him
        return [next_success_step(steps), true] if stp.on_failure == :PASS
        return [next_failure_step(steps), false] if stp.on_failure == :FAIL

        [next_step(stp.on_failure, steps), false]
      when :for_step_error,
           :for_fail_error,
           :for_pass_error,
           :for_octo_error,
           :for_wrap_error
        return [nil, false] if stp.finish_him == :on_error
        return [next_failure_step(steps), false] if stp.on_error.nil?
        return [nil, false] if stp.on_error == :finish_him
        return [next_success_step(steps), true] if stp.on_error == :PASS
        return [next_failure_step(steps), false] if stp.on_error == :FAIL

        [next_step(stp.on_error, steps), false]
      end
    end

    def self.compose_condition_outcome(flow, _stp, steps)
      case flow
      when :for_if_pass_success, :for_unless_pass_success
        [next_success_step(steps), nil]
      when :for_if_pass_failure, :for_unless_pass_failure
        [next_success_step(steps[1..]), nil]
      when :for_if_fail_success, :for_unless_fail_success
        [next_failure_step(steps), nil]
      when :for_if_fail_failure, :for_unless_fail_failure
        [next_failure_step(steps[1..]), nil]
      end
    end

    def self.next_success_step(steps)
      steps.detect do |flow_step|
        [
          Decouplio::Steps::Step,
          Decouplio::Steps::Pass,
          Decouplio::Steps::IfConditionPass,
          Decouplio::Steps::UnlessConditionPass,
          Decouplio::Steps::OctoByKey,
          Decouplio::Steps::OctoByMethod,
          Decouplio::Steps::InnerActionStep,
          Decouplio::Steps::InnerActionPass,
          Decouplio::Steps::ServiceAsStep,
          Decouplio::Steps::ServiceAsPass,
          Decouplio::Steps::ResqPass,
          Decouplio::Steps::ResqWithMappingPass,
          Decouplio::Steps::Wrap,
          Decouplio::Steps::WrapWithClass,
          Decouplio::Steps::WrapWithClassMethod
        ].include?(flow_step.class)
      end
    end

    def self.next_failure_step(steps)
      steps.detect do |flow_step|
        [
          Decouplio::Steps::Fail,
          Decouplio::Steps::IfConditionFail,
          Decouplio::Steps::UnlessConditionFail,
          Decouplio::Steps::InnerActionFail,
          Decouplio::Steps::ServiceAsFail,
          Decouplio::Steps::ResqFail,
          Decouplio::Steps::ResqWithMappingFail
        ].include?(flow_step.class)
      end
    end

    def self.next_step(step_name, steps)
      steps.each_with_index do |flow_step, index|
        if flow_step.name == step_name
          if [
            Decouplio::Steps::IfConditionFail,
            Decouplio::Steps::UnlessConditionFail,
            Decouplio::Steps::IfConditionPass,
            Decouplio::Steps::UnlessConditionPass
          ].include?(steps[index - 1].class)
            return steps[index - 1]
          else
            return flow_step
          end
        end
      end
      raise StandardError, 'Most likely it is a bug, please create an issue here https://github.com/differencialx/decouplio/issues'
    end

    def self.validate_wrap(logic_container_raw_data)
      logic_container_raw_data.steps.map(&:class).each do |step_class|
        next unless Decouplio::Const::Flows::OCTO_CLASSES.include?(step_class)

        raise Decouplio::Errors::OctoInsideWrapError
      end
    end
  end
end
