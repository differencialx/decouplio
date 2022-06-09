# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Aide < Decouplio::Steps::BaseStep
      def initialize(name:, aide_class:, aide_options:, on_success_type:, on_failure_type:)
        super()
        @name = name
        @aide_class = aide_class
        @aide_options = aide_options
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        result = @aide_class.call(
          ctx: instance.ctx,
          error_store: instance.error_store,
          **@aide_options
        )
        resolve(instance: instance, result: result)
      end

      def resolve(instance:, result:)
        Decouplio::Steps::Shared::FailResolver.call(
          instance: instance,
          result: result,
          on_success_type: @on_success_type,
          on_failure_type: @on_failure_type
        )
      end
    end
  end
end
