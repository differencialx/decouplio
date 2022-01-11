module Decouplio
  class LogicComposer
    class << self
      def compose(logic_container:)
        main_flow = logic_container.steps
        squads = logic_container.squads

        main_flow = process_strategies(main_flow, squads)
        main_flow = main_flow.keep_if do |stp|
          stp.is_main_flow?
        end
        main_flow = process_conditions(main_flow)
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
              squads[options[:squad]] || squads[options[:step]] || squads[options[:action]]
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
          if stp.is_step? || stp.is_pass?
            stp.on_success = next_success_step(steps, idx, stp.on_success)
            stp.on_failure = next_failure_step(steps, idx, stp.on_failure)
          elsif stp.is_strategy?
            stp.hash_case.each do |strg_key, strg_stp|
              strg_stp.on_success = next_success_step(steps, idx, strg_stp.on_success)
              strg_stp.on_failure = next_failure_step(steps, idx, strg_stp.on_failure)
            end
            stp.on_success = next_success_step(steps, idx, stp.on_success)
            stp.on_failure = next_failure_step(steps, idx, stp.on_failure)
          elsif stp.is_fail?
            stp.on_failure = next_failure_step(steps, idx, stp.on_failure)
          end
          stp
        end
      end

      def next_success_step(steps, idx, value)
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
        nil
      end

      def next_failure_step(steps, idx, value)
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
        nil
      end
    end
  end
end
