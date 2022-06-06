# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Octo < BaseStep
      attr_accessor :hash_case

      def initialize(name:, ctx_key:, method:)
        super()
        @name = name
        @ctx_key = ctx_key
        @method = method
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        if @method
          instance.send(@method, **instance.ctx)
        else
          instance[@ctx_key]
        end
      end
    end
  end
end
