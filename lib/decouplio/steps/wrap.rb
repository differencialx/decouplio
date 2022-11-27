# frozen_string_literal: true

module Decouplio
  module Steps
    class Wrap < Decouplio::Steps::BaseWrap
      def initialize(
        name,
        wrap_block,
        on_success,
        on_failure,
        on_error,
        finish_him
      )
        super()
        @name = name
        @wrap_block = wrap_block
        @on_success = on_success
        @on_failure = on_failure
        @on_error = on_error
        @finish_him = finish_him
      end

      def process(instance)
        instance.railway_flow << @name

        next_step = @wrap_first_step
        next_step = next_step.process(instance) while next_step

        if instance.success?
          instance.success = @on_success_resolver
          @on_success
        else
          instance.success = @on_failure_resolver
          @on_failure
        end
      end
    end
  end
end
