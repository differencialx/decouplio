# frozen_string_literal: true

module Decouplio
  module Steps
    class OctoByMethod < Decouplio::Steps::BaseOcto
      def initialize(name, by_method, hash_case, on_success, on_failure, on_error, finish_him)
        super()
        @name = name
        @by_method = by_method
        @hash_case = hash_case
        @on_success = on_success
        @on_failure = on_failure
        @on_error = on_error
        @finish_him = finish_him
      end

      def process(instance)
        instance.railway_flow << @name
        @hash_case[instance.send(@by_method)]
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
