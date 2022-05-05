# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class UnlessConditionFail < Decouplio::Steps::BaseStep
      def initialize(name:)
        super()
        @name = name
      end

      def process(instance:)
        result = instance.send(@name, **instance.ctx)

        resolve(result: result, instance: instance)
      end

      private

      def resolve(result:, instance:)
        instance.fail_action

        result ? Decouplio::Const::Results::FAIL : Decouplio::Const::Results::PASS
      end
    end
  end
end
