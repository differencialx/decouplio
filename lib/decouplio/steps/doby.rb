# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Doby < Decouplio::Steps::BaseStep
      def initialize(name:, doby_class:, doby_options:, on_success_type:, on_failure_type:)
        super()
        @name = name
        @doby_class = doby_class
        @doby_options = doby_options
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        result = @doby_class.call(
          ctx: instance.ctx,
          ms: instance.meta_store,
          **@doby_options
        )
        resolve(result: result, instance: instance)
      end

      def resolve(result:, instance:)
        Decouplio::Steps::Shared::StepResolver.call(
          instance: instance,
          result: result,
          on_success_type: @on_success_type,
          on_failure_type: @on_failure_type
        )
      end
    end
  end
end
