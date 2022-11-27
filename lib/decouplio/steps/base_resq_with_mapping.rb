# frozen_string_literal: true

module Decouplio
  module Steps
    class BaseResqWithMapping
      attr_reader :name, :step_to_resq, :mappings

      def initialize(name, mappings)
        @name = name
        @mappings = mappings
      end

      def process(instance)
        result = @step_to_resq.process(instance)
      rescue *@mappings.keys => error
        handler_method = @mappings[error.class]

        raise error unless handler_method

        instance.railway_flow << handler_method
        instance.send(handler_method, error)

        instance.success = @step_to_resq.on_error_resolver
        @step_to_resq.on_error
      else
        result
      end

      def _add_step_to_resq(stp)
        @step_to_resq = stp
      end
    end
  end
end
