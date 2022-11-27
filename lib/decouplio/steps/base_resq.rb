# frozen_string_literal: true

module Decouplio
  module Steps
    class BaseResq
      attr_reader :name, :step_to_resq, :mappings, :handler_method

      def initialize(name, handler_method)
        @name = name
        @handler_method = handler_method
      end

      def process(instance)
        result = @step_to_resq.process(instance)
      rescue StandardError => error
        instance.railway_flow << @handler_method
        instance.send(@handler_method, error)

        instance.success = @step_to_resq.on_error_resolver
        @step_to_resq.on_error
      else
        result
      end

      def _add_on_error(on_error)
        @on_error = on_error
      end

      def _add_on_error_resolver(resolver)
        @on_error_resolver = resolver
      end

      def _add_step_to_resq(stp)
        @step_to_resq = stp
      end
    end
  end
end
