# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class ServicePass < Decouplio::Steps::BaseStep
      def initialize(name:, service:, args:, on_success_type:, on_failure_type:)
        super()
        @name = name
        @service = service
        @args = args
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        @service.call(
          ctx: instance.ctx,
          ms: instance.meta_store,
          **@args
        )

        resolve(instance: instance)
      end

      private

      def resolve(instance:)
        instance.pass_action

        if @on_success_type == Decouplio::Const::Results::FINISH_HIM
          Decouplio::Const::Results::FINISH_HIM
        else
          Decouplio::Const::Results::PASS
        end
      end
    end
  end
end
