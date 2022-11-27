# frozen_string_literal: true

module Decouplio
  module Steps
    class BaseWrap
      attr_reader :name,
                  :on_success,
                  :on_failure,
                  :on_error,
                  :finish_him,
                  :on_error_resolver,
                  :wrap_block

      def _add_next_steps(steps)
        @on_success, @on_failure, @on_error = steps
      end

      def _add_resolvers(resolvers)
        @on_success_resolver, @on_failure_resolver, @on_error_resolver = resolvers
      end

      def _add_wrap_first_step(wrap_first_step)
        @wrap_first_step = wrap_first_step
      end
    end
  end
end
