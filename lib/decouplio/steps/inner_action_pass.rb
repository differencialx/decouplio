# frozen_string_literal: true

module Decouplio
  module Steps
    class InnerActionPass < Decouplio::Steps::BaseInnerAction
      def process(instance)
        instance.railway_flow << @name

        @action_class.call(
          _parent_meta_store: instance.ms,
          _parent_railway_flow: instance.railway_flow,
          _parent_ctx: instance.ctx
        )

        instance.success = @on_success_resolver
        @on_success
      end
    end
  end
end
