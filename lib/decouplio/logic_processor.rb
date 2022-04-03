require_relative 'step'

module Decouplio
  class LogicProcessor
    class << self
      def call(flow:, instance:)
        first_step = flow.first
        process_step(first_step, instance)
      end

      private

      def process_step(stp, instance)
        return if stp.nil?

        if stp.is_step? || stp.is_pass? || stp.is_fail?
          process_regular_step(stp, instance)
        elsif stp.is_condition?
          process_condition_step(stp, instance)
        elsif stp.is_strategy?
          process_strategy_step(stp, instance)
        elsif stp.is_action?
          process_action_step(stp, instance)
        elsif stp.is_wrap?
          process_wrap_step(stp, instance)
        end
      end

      def process_regular_step(stp, instance)
        # binding.pry
        result = call_instance_method(instance, stp.instance_method) || stp.is_pass?
        instance.append_railway_flow(stp.instance_method)

        if stp.is_step? || stp.is_pass?
          if result && instance.success?
            next_step = stp.on_success
            success_of_failure_way = :on_success
          else
            next_step = stp.on_failure
            success_of_failure_way = :on_failure
            if stp.is_finish_him?(railway_flow: success_of_failure_way) || !next_step || next_step.is_fail_with_if?
              instance.fail_action
            end
          end
        elsif stp.is_fail?
          next_step = stp.on_failure
          success_of_failure_way = :on_failure
          instance.fail_action
        end

        unless stp.is_finish_him?(railway_flow: success_of_failure_way)
          process_step(next_step, instance)
        end
      end

      def process_strategy_step(stp, instance)
        strg_key_value = stp.hash_case[instance[stp.ctx_key]]

        # TODO: raise error if ctx_key is not set

        if strg_key_value.is_squad?
          next_step = strg_key_value.logic_container.steps.first
        elsif strg_key_value.is_step?
          next_step = strg_key_value
        end
        process_step(next_step, instance)
      end

      def process_action_step(stp, instance)
        instance.append_railway_flow(stp.instance_method)
        result = stp.action.call(parent_ctx: instance.context, parent_railway_flow: instance.railway_flow)

        if result.success?
          process_step(stp.on_success, instance)
        else
          instance.errors.merge!(result.errors)
          process_step(stp.on_failure, instance)
        end
      end

      def process_wrap_step(stp, instance)
        instance.append_railway_flow(stp.instance_method)

        if stp.has_specific_wrap?
          stp.klass.public_send(stp.method) do
            process_step(stp.wrap_inner_flow, instance)
          end
        else
          process_step(stp.wrap_inner_flow, instance)
        end

        success_of_failure_way = instance.success? ? :on_success : :on_failure
        next_step = instance.success? ? stp.on_success : stp.on_failure

        if success_of_failure_way == :on_failure && next_step&.is_step_type?
          instance.fail_wrap_inner_action
        end

        unless stp.is_finish_him?(railway_flow: success_of_failure_way)
          process_step(next_step, instance)
        end
      end

      def process_condition_step(stp, instance)
        result = call_instance_method(instance, stp.instance_method)

        result = stp.is_if? ? result : !result

        process_step(result ? stp.on_success : stp.on_failure, instance)
      end

      def call_instance_method(instance, stp)
        instance.invoke_step(stp)
      end
    end
  end
end
