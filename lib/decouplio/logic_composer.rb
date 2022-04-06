require_relative 'errors/undefined_step_method_error'
require_relative 'step'

module Decouplio
  class LogicComposer
    NO_STEP_FOUND = nil

    class << self
      def compose(logic_container:)
        main_flow = logic_container.steps
        # TODO: raise error if first step is fail
        squads = logic_container.squads

        main_flow = process_strategies(main_flow, squads)
        main_flow = main_flow.keep_if do |stp|
          stp.is_main_flow?
        end
        main_flow = process_conditions(main_flow)
        main_flow = process_resq(main_flow)
        main_flow = process_main_flow(main_flow)
        main_flow
      end

      private

      def process_strategies(main_flow, squads)
        main_flow.map do |stp|
          next stp unless stp.is_strategy?

          stp.hash_case = stp.hash_case.map do |strg_key, options|
            [
              strg_key,
              squads[options[:squad]] || Decouplio::Step.new(
                instance_method: options[:step],
                type: Decouplio::Step::STEP_TYPE
              )
            ]
          end.to_h

          stp
        end
      end

      def process_conditions(flow_steps)
        flow_steps = flow_steps.each_with_index.map do |stp, idx|
          if stp.has_condition?
            stp.condition.merge!(
              on_success: stp,
              on_failure: stp.is_step_type? ? next_success_step(flow_steps, idx, stp.on_success) : next_failure_step(flow_steps, idx, stp.on_failure)
            )
            stp.condition = Step.new(**stp.condition)
          end
          stp
        end.flatten
      end

      def process_main_flow(steps)
        steps.each_with_index.map do |stp, idx|
          if stp.is_step? || stp.is_pass? || stp.is_action? || stp.is_wrap? || stp.is_resq?
            stp.on_success = next_success_step(steps, idx, stp.on_success)
            stp.on_failure = next_failure_step(steps, idx, stp.on_failure)
          elsif stp.is_strategy?
            # TODO: Add specs for strategy on_success on_failure
            stp.on_success = next_success_step(steps, idx, stp.on_success)
            stp.on_failure = next_failure_step(steps, idx, stp.on_failure)

            stp.hash_case.each do |strg_key, strg_steps|
              if strg_steps.is_squad?
                strg_steps.logic_container.steps = compose(logic_container: strg_steps.logic_container)
                strg_steps.logic_container.steps.each do |strg_step|
                  strg_step.on_success = next_success_step(steps, idx, strg_step.on_success)
                  strg_step.on_failure = next_failure_step(steps, idx, strg_step.on_failure)
                  if strg_step.on_success&.is_condition?
                    strg_step.on_success.on_success = next_success_step(steps, idx, strg_step.on_success.on_success)
                    strg_step.on_success.on_failure = next_failure_step(steps, idx, strg_step.on_success.on_failure)
                  end
                  if strg_step.on_failure&.is_condition?
                    strg_step.on_failure.on_success = next_success_step(steps, idx, strg_step.on_failure.on_success)
                    strg_step.on_failure.on_failure = next_failure_step(steps, idx, strg_step.on_failure.on_failure)
                  end
                  if stp.has_resq?
                    strg_step.resq ||= stp.resq
                  end
                end
              elsif strg_steps.is_step?
                strg_steps.on_success = next_success_step(steps, idx, strg_steps.on_success)
                strg_steps.on_failure = next_failure_step(steps, idx, strg_steps.on_failure)
                if strg_steps.on_success&.is_condition?
                  strg_steps.on_success.on_success = next_success_step(steps, idx, strg_steps.on_success.on_success)
                  strg_steps.on_success.on_failure = next_failure_step(steps, idx, strg_steps.on_success.on_failure)
                end
                if strg_steps.on_failure&.is_condition?
                  strg_steps.on_failure.on_success = next_success_step(steps, idx, strg_steps.on_failure.on_success)
                  strg_steps.on_failure.on_failure = next_failure_step(steps, idx, strg_steps.on_failure.on_failure)
                end
                if stp.has_resq?
                  strg_steps.resq ||= stp.resq
                end
              end

              stp.hash_case[strg_key] = strg_steps
            end
            stp.resq = nil
          elsif stp.is_fail?
            stp.on_failure = next_failure_step(steps, idx, stp.on_failure)
          end
          stp
        end
      end

      def process_resq(steps)
        steps_to_filter_out = []

        steps.each_with_index do |stp, index|
          next unless stp.is_resq?

          prev_step = steps[index - 1]
          # TODO: mayby it will be better to redefine resq= method for step, and if it's strategy, when assign resq for
          # for all strategy steps
          prev_step.resq = {
            handlers: stp.handlers,
            klass: stp.klass,
            method: stp.method
          }
          steps_to_filter_out << stp
        end

        steps.reject { |stp| steps_to_filter_out.include?(stp)  }
      end

      def next_success_step(steps, idx, value)
        return value if value.is_a?(Decouplio::Step)

        if value.is_a?(Symbol)
          steps[(idx + 1)..-1].each do |stp|
            if stp.instance_method == value
              if stp.has_condition?
                return stp.condition
              else
                return stp
              end
            end
          end
        else
          steps[(idx + 1)..-1].each do |stp|
            if stp.is_step_type?
              if stp.has_condition?
                return stp.condition
              else
                return stp
              end
            end
          end
        end

        NO_STEP_FOUND
      end

      def next_failure_step(steps, idx, value)
        return value if value.is_a?(Decouplio::Step)

        if value.is_a?(Symbol)
          steps[(idx + 1)..-1].each do |stp|
            if stp.instance_method == value
              if stp.has_condition?
                return stp.condition
              else
                return stp
              end
            end
          end
        else
          steps[(idx + 1)..-1].each do |stp|
            if stp.is_fail_type?
              if stp.has_condition?
                return stp.condition
              else
                return stp
              end
            end
          end
        end

        NO_STEP_FOUND
      end
    end
  end
end
