# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class BaseResq < BaseStep
      def initialize(handler_hash:, step_to_resq:)
        super()
        @handler_hash = handler_hash
        @step_to_resq = step_to_resq
      end

      def process(instance:)
        result = @step_to_resq.process(instance: instance)
      rescue *@handler_hash.keys => e
        handler_method = @handler_hash[e.class]

        raise e unless handler_method

        instance.append_railway_flow(handler_method)
        instance.public_send(handler_method, e, **instance.ctx)

        instance.fail_action
        Decouplio::Const::Results::ERROR
      else
        result
      end
    end
  end
end
