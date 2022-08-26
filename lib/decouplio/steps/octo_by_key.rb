# frozen_string_literal: true

module Decouplio
  module Steps
    class OctoByKey < Decouplio::Steps::BaseOcto
      def initialize(name, by_key, hash_case, on_success, on_failure, on_error, finish_him)
        super()
        @name = name
        @by_key = by_key
        @hash_case = hash_case
        @on_success = on_success
        @on_failure = on_failure
        @on_error = on_error
        @finish_him = finish_him
      end

      def process(instance)
        instance.railway_flow << @name
        @hash_case[instance.ctx[@by_key]]
      end

      def _add_next_steps(steps)
        @on_success, @on_failure, @on_error = steps
      end

      def _add_resolvers(resolvers)
        @on_success_resolver, @on_failure_resolver, @on_error_resolver = resolvers
      end
    end
  end
end
