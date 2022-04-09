require_relative 'base_step'

module Decouplio
  module Steps
    class BaseUnlessCondition < Decouplio::Steps::BaseStep
      def initialize(name:)
        @name = name
      end

      def process(instance:)
        result = instance.send(@name, **instance.ctx)

        resolve(result: result, instance: instance)
      end

      private

      def resolve(result:, instance:)
        result ? Decouplio::Const::FAIL : Decouplio::Const::PASS
      end
    end
  end
end
