# frozen_string_literal: true

require_relative '../const/error_messages'

module Decouplio
  module Errors
    class ExecutionError < StandardError
      attr_reader :action

      def initialize(action:)
        @action = action
        super(message)
      end

      def message
        Decouplio::Const::ErrorMessages::EXECUTION_ERROR
      end
    end
  end
end
