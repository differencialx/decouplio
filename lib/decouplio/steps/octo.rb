# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Octo < BaseStep
      attr_accessor :hash_case

      def initialize(name:, ctx_key:)
        super()
        @name = name
        @ctx_key = ctx_key
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        instance[@ctx_key]
      end
    end
  end
end
