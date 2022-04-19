require_relative 'base_step'

module Decouplio
  module Steps
    class BaseIfCondition < Decouplio::Steps::BaseStep
      # Don't really like such inheritance for conditions
      # Maybe would be better to create condition classes
      # without inheritance
      def initialize(name:)
        @name = name
      end

      def process(instance:)
        result = instance.send(@name, **instance.ctx)

        resolve(result: result, instance: instance)
      end

      private

      def resolve(result:, instance:)
        result ? Decouplio::Const::Results::PASS : Decouplio::Const::Results::FAIL
      end
    end
  end
end
