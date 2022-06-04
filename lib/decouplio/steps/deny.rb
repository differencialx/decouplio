# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Deny < Decouplio::Steps::BaseStep
      def initialize(name:, deny_class:, deny_options:)
        super()
        @name = name
        @deny_class = deny_class
        @deny_options = deny_options
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        @deny_class.call(
          ctx: instance.ctx,
          error_store: instance.error_store,
          **@deny_options
        )
        resolve(instance: instance)
      end

      def resolve(instance:)
        instance.fail_action
        Decouplio::Const::Results::FAIL
      end
    end
  end
end
