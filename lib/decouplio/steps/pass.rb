require_relative 'base_step'

module Decouplio
  module Steps
    class Pass < Decouplio::Steps::BaseStep
      def initialize(name:, finish_him:)
        @name = name
        @finish_him = finish_him
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        instance.send(@name, **instance.ctx)

        resolve
      end

      private

      def resolve
        @finish_him ? Decouplio::Const::Results::FINISH_HIM : Decouplio::Const::Results::PASS
      end
    end
  end
end
