module Decouplio
  class Processor
    class << self
      def call(first_step:, steps_pool:, steps_flow:, instance:)
        process(first_step, instance, steps_pool, steps_flow)
      end

      private

      def process(next_step_name, instance, steps_pool, steps_flow)
        while next_step_name do
          # binding.pry
          result = steps_pool[next_step_name].process(instance: instance)
          next_step_name = steps_flow[next_step_name][result]
        end
      end
    end
  end
end
