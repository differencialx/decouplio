module Decouplio
  class LogicProcessor
    MAIN_FLOW = :main

    class << self
      def call(logic:, instance:)
        first_step = logic[MAIN_FLOW].values.first
        process_step(first_step, instance)
      end

      private

      def process_step(stp, instance)
        return if stp.nil?

        # binding.pry
        if stp.is_step? || stp.is_pass? || stp.is_fail?
          process_regular_step(stp, instance)
        elsif stp.is_action?
          process_action_step(stp, instance)
        end
      end

      def process_regular_step(stp, instance)
        if stp.has_condition?
          condition_result = process_condition_step(stp, instance)
          unless condition_result
            return process_step(
              if stp.is_step? || stp.is_pass?
                stp.on_success
              elsif stp.is_fail?
                stp.on_failure
              end,
              instance
            )
          end
        end

        result = call_instance_method(instance, stp.instance_method) || stp.is_pass?
        instance.railway_flow << stp.instance_method

        if stp.is_step? || stp.is_pass?
          if result && instance.success?
            next_step = stp.on_success
            success_of_failure_way = :on_success
          else
            next_step = stp.on_failure
            success_of_failure_way = :on_failure
            # binding.pry
            instance.fail_action if stp.is_finish_him?(railway_flow: success_of_failure_way)
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

      def process_condition_step(stp, instance)
        result = call_instance_method(instance, stp.condition[:method])

        stp.is_if? ? result : !result
      end

      def call_instance_method(instance, stp)
        instance.public_send(stp, **instance.ctx)
      end
    end
  end
end
