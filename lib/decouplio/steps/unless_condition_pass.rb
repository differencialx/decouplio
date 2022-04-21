# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class UnlessConditionPass < Decouplio::Steps::BaseStep
      def initialize(name:)
        @name = name
        super()
      end

      def process(instance:)
        result = instance.send(@name, **instance.ctx)

        resolve(result: result)
      end

      private

      def resolve(result:)
        result ? Decouplio::Const::Results::FAIL : Decouplio::Const::Results::PASS
      end
    end
  end
end
