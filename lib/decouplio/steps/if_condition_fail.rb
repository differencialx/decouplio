# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class IfConditionFail < Decouplio::Steps::BaseStep
      def initialize(name:)
        @name = name
        super()
      end

      def process(instance:)
        result = instance.send(@name, **instance.ctx)

        resolve(result: result, instance: instance)
      end

      private

      def resolve(result:, instance:)
        instance.fail_action

        result ? Decouplio::Const::Results::PASS : Decouplio::Const::Results::FAIL
      end
    end
  end
end
