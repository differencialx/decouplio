# frozen_string_literal: true

module Decouplio
  module Steps
    class ServiceAsPass < BaseServiceStep
      def process(instance)
        instance.railway_flow << @name

        @service_class.call(instance.ctx, instance.ms, **@args)

        instance.success = @on_success_resolver
        @on_success
      end
    end
  end
end
