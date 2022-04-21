# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Fail < BaseStep
      def initialize(name:, finish_him:)
        @name = name
        @finish_him = finish_him
        super()
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        instance.send(@name, **instance.ctx)

        resolve(instance: instance)
      end

      private

      def resolve(instance:)
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
