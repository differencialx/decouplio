# frozen_string_literal: true

module Decouplio
  module Steps
    class BaseCondition
      attr_reader :condition_method

      alias name condition_method

      def initialize(condition_method)
        @condition_method = condition_method
      end

      def _add_next_steps(steps)
        @perform_condition_step, @skip_condition_step = steps
      end

      def _add_resolvers(_); end
    end
  end
end
