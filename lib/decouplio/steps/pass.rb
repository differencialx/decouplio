# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Pass < Decouplio::Steps::BaseStep
      def initialize(name:, on_success_type:)
        super()
        @name = name
        @on_success_type = on_success_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        instance.send(@name, **instance.ctx)

        resolve(instance: instance)
      end

      private

      def resolve(instance:)
        instance.pass_action

        if @on_success_type == Decouplio::Const::Results::FINISH_HIM
          Decouplio::Const::Results::FINISH_HIM
        else
          instance.pass_action
          Decouplio::Const::Results::PASS
        end
      end
    end
  end
end
