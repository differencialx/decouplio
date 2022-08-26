# frozen_string_literal: true

module Decouplio
  module Steps
    class BaseInnerAction
      attr_reader :name, :on_success, :on_failure, :on_error, :finish_him, :on_error_resolver

      def initialize(name, action_class, on_success, on_failure, on_error, finish_him)
        @name = name
        @action_class = action_class
        @on_success = on_success
        @on_failure = on_failure
        @on_error = on_error
        @finish_him = finish_him
      end

      def process(instance)
        instance.railway_flow << @name
        result = @action_class.call(
          _parent_meta_store: instance.ms,
          _parent_railway_flow: instance.railway_flow,
          _parent_ctx: instance.ctx
        )
        if result.success?
          instance.success = @on_success_resolver
          @on_success
        else
          instance.success = @on_failure_resolver
          @on_failure
        end
      end

      def _add_next_steps(steps)
        @on_success, @on_failure, @on_error = steps
      end

      def _add_resolvers(resolvers)
        @on_success_resolver, @on_failure_resolver = resolvers
      end
    end
  end
end
