# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Doby < Decouplio::Steps::BaseStep
      def initialize(name:, doby_class:, doby_options:)
        super()
        @name = name
        @doby_class = doby_class
        @doby_options = doby_options
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        result = @doby_class.call(ctx: instance.ctx, **@doby_options)
        resolve(result: result, instance: instance)
      end

      def resolve(result:, instance:)
        if result
          instance.pass_action
          Decouplio::Const::Results::PASS
        else
          instance.fail_action
          Decouplio::Const::Results::FAIL
        end
      end
    end
  end
end
