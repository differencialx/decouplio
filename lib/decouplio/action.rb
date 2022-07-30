# frozen_string_literal: true

require 'forwardable'
require_relative 'flow'
require_relative 'processor'
require_relative 'default_meta_store'
require_relative 'action_state_printer'
require_relative 'errors/logic_redefinition_error'
require_relative 'errors/logic_is_not_defined_error'
require_relative 'errors/execution_error'
require_relative 'const/results'

module Decouplio
  class Action
    attr_reader :railway_flow, :ctx, :meta_store

    alias ms meta_store

    def initialize(
      parent_railway_flow: nil, parent_ctx: nil, meta_store:, **params
    )
      @meta_store = meta_store
      @ctx = parent_ctx || params
      @railway_flow = parent_railway_flow || []
      @failure = false
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

    def append_railway_flow(stp)
      railway_flow << stp
    end

    def inspect
      Decouplio::ActionStatePrinter.call(self)
    end

    def to_s
      inspect
    end

    class << self
      attr_accessor :meta_store

      def meta_store_class(klass)
        self.meta_store = klass
      end

      def call(**params)
        instance = new(
          {
            meta_store: meta_store.new
          }.merge(**params)
        )
        Decouplio::Processor.call(instance: instance, **@flow)
        instance
      end

      def call!(**params)
        instance = call(**params)
        if instance.failure?
          raise Decouplio::Errors::ExecutionError.new(
            action: instance
          )
        else
          instance
        end
      end

      private

      def inherited(child_class)
        child_class.meta_store = meta_store || Decouplio::DefaultMetaStore
      end

      def logic(&block)
        if @flow && !@flow[:first_step].nil?
          raise Decouplio::Errors::LogicRedefinitionError.new(
            errored_option: to_s
          )
        end
        if block_given?
          @flow = Decouplio::Flow.call(logic: block, action_class: self)

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
