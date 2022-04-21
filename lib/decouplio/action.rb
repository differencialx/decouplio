# frozen_string_literal: true

require 'pry' # TODO: remove
require_relative 'flow'
require_relative 'processor'
require_relative 'default_error_handler'
require 'forwardable'

module Decouplio
  class Action
    extend Forwardable
    def_delegators :@error_store, :errors, :add_error
    attr_reader :railway_flow, :ctx

    def initialize(
      parent_railway_flow: nil, parent_ctx: nil, parent_instance: nil, wrapper: false, error_store:, **params
    )
      @error_store = error_store
      @ctx = parent_ctx || params
      @railway_flow = parent_railway_flow || []
      @failure = false
      @instance = parent_instance || self
    end

    def [](key)
      @ctx[key]
    end

    def success?
      !@failure
    end

    def failure?
      @failure
    end

    def fail_action
      @failure = true
    end

    def pass_action
      @failure = false
    end

    def invoke_step(method_name)
      @instance.send(method_name, **@instance.ctx)
    end

    def append_railway_flow(stp)
      @instance.railway_flow << stp
    end

    # def inspect
    # TODO: Redefine to show only useful information
    # super
    # end

    class << self
      attr_accessor :error_store

      # TODO: remove Debug accessors
      attr_reader :palps, :main_flow

      def error_store_instance(handler_class)
        self.error_store = handler_class
      end

      def call(**params)
        instance = new(error_store: error_store.new, **params)
        Decouplio::Processor.call(instance: instance, **@flow)
        # TODO: process block with after actions
        instance
      end

      def call!(**params)
        # TODO: raises an error if instance failed
      end

      private

      def inherited(child_class)
        child_class.error_store = error_store || Decouplio::DefaultErrorHandler
      end

      def logic(&block)
        # TODO: raise error if @main flow is not empty, check the case when several logic block are difined
        if block_given?
          @flow = Decouplio::Flow.call(logic: block)
        else
          # TODO: rails error if no logic is provided
        end
      end
    end
  end
end
