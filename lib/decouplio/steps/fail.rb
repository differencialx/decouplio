require_relative 'base_step'

module Decouplio
  module Steps
    class Fail < BaseStep
      def initialize(name:, finish_him:)
        @name = name
        @finish_him = finish_him
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        result = instance.send(@name, **instance.ctx)

        resolve(result: result, instance: instance)
      end

      private

      def resolve(result:, instance:)
        result = !!result

        instance.fail_action

        return Decouplio::Const::Results::FAIL unless @finish_him

        if @finish_him == true
          Decouplio::Const::Results::FINISH_HIM
        else
          Decouplio::Const::Results::FAIL
        end
      end
    end
  end
end
