# frozen_string_literal: true

require 'pry'
require_relative 'logic_container'
require_relative 'logic_composer'
require_relative 'logic_processor'
require_relative 'errors/step_argument_error'
require_relative 'default_error_handler'
require 'forwardable'

module Decouplio
  class Action
    extend Forwardable
    def_delegators :@error_store, :errors, :add_error
    attr_reader :ctx, :railway_flow

    def initialize(parent_instance: nil, wrapper: false, error_store:,  **params)
      @error_store = error_store
      @ctx = params
      @railway_flow = []
      @failure = false
    end

    def [](key)
      ctx[key]
    end

    def success?
      !failure?
    end

    def failure?
      !errors.empty? || @failure
    end

    def fail_action
      @failure = true
    end

    def inspect
      # Redefine to show only useful information
      super
    end

    class << self
      attr_accessor :error_store

      def inherited(child_class)
        child_class.error_store = self.error_store || Decouplio::DefaultErrorHandler.new
      end

      def call(**params)
        instance = self.new(error_store: error_store, **params)
        Decouplio::LogicProcessor.call(logic: @logic, instance: instance)
        instance
      end

      def call!(**params)
        # raises an error
      end

      private

      def logic(&block)
        if block_given?
          @logic = Decouplio::LogicComposer.compose(
            logic_container: Class.new(Decouplio::LogicContainer, &block)
          )
        else
          # Message that no logic is provided
        end
      end
    end
  end
end
