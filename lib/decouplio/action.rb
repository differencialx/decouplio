# frozen_string_literal: true

require 'forwardable'
require_relative 'flow'
require_relative 'processor'
require_relative 'default_error_handler'
require_relative 'errors/logic_redefinition_error'
require_relative 'errors/logic_is_not_defined_error'

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

    def inspect
      <<~INSPECT
        Result: #{self.success? ? 'success' : 'failure'}

        Railway Flow:
          #{ railway_flow.join(' -> ') }

        Context:
          #{ctx}

        Errors:
          #{errors}
      INSPECT
    end

    class << self
      attr_accessor :error_store

      def error_store_instance(handler_class)
        self.error_store = handler_class
      end

      def call(**params)
        instance = new(error_store: error_store.new, **params)
        Decouplio::Processor.call(instance: instance, **@flow)
        # TODO: process block with after actions
        instance
      end

      private

      def inherited(child_class)
        child_class.error_store = error_store || Decouplio::DefaultErrorHandler
      end

      def logic(&block)
        if @flow && !@flow[:first_step].nil?
          raise Decouplio::Errors::LogicRedefinitionError.new(
            errored_option: to_s
          )
        end
        if block_given?
          @flow = Decouplio::Flow.call(logic: block)

          if @flow && @flow[:first_step].nil?
            raise Decouplio::Errors::LogicIsNotDefinedError.new(
              errored_option: to_s
            )
          end
        else
          raise Decouplio::Errors::LogicIsNotDefinedError.new(
            errored_option: to_s
          )
        end
      end
    end
  end
end
