module Decouplio
  class LogicComposer
    FLOW_IDX = 1
    STEP_NAME_IDX = 0
    STEP_OPTIONS_IDX = 1
    STEP_TYPES = %i[step if unless pass strg]
    FAIL_TYPES = %i[fail]

    class << self
      def compose(logic_container:)
        logic = logic_container.steps.each do |flow|
          compose_flow(flow[FLOW_IDX].to_a)
        end
        # binding.pry
      end

      private

      def compose_flow(flow)
        flow.each_with_index do |entry, idx|
          stp = entry[STEP_OPTIONS_IDX]
          if stp.is_step?
            stp.on_success = obtain_next_step(stp.on_success, flow, idx, STEP_TYPES)
            stp.on_failure = obtain_next_step(stp.on_failure, flow, idx, FAIL_TYPES)
          elsif stp.is_fail?
            stp.on_failure = obtain_next_step(stp.on_failure, flow, idx, FAIL_TYPES)
          elsif stp.is_pass?
            stp.on_success = obtain_next_step(stp.on_success, flow, idx, STEP_TYPES)
          elsif stp.is_strategy?
            ''
          end
        end
      end

      def next_step(steps_array, range, types)
        steps_array[*range].select { |stp| types.include?(stp[STEP_OPTIONS_IDX].type) }.dig(0,1)
      end

      def obtain_next_step(current_value, flow, idx, types)
        if current_value.is_a?(Symbol)
          return :finish_him if current_value == :finish_him
          return flow.select { |stp| stp[STEP_NAME_IDX] == current_value }.dig(0, 1)
        end

        next_step(flow, [(idx + 1)..-1], types)
      end
    end
  end
end
