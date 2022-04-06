# frozen_string_literal: true

require 'pry' # TODO: remove
require_relative 'flow'
require_relative 'logic_processor'
require_relative 'errors/step_argument_error'
require_relative 'default_error_handler'
require 'forwardable'

module Decouplio
  class Action
    PASS = true

    extend Forwardable
    def_delegators :@error_store, :errors, :add_error
    attr_reader :railway_flow, :context

    def initialize(
      parent_railway_flow: nil, parent_ctx: nil, parent_instance: nil, wrapper: false, error_store:, **params
    )
      @error_store = error_store
      @context = parent_ctx || params
      @railway_flow = parent_railway_flow || []
      @failure = false
      @wrap_inner_action_failure = false
      @instance = parent_instance || self
    end

    def [](key)
      context[key]
    end

    def success?
      !failure?
    end

    def failure?
      (@failure || !errors.empty?) && !@wrap_inner_action_failure
    end

    def fail_action
      @failure = true
    end

    def fail_wrap_inner_action
      @wrap_inner_action_failure = true
    end

    def invoke_step(method_name)
      @instance.send(method_name, **@instance.ctx)
    end

    def append_railway_flow(stp)
      @instance.railway_flow << stp
    end

    def ctx
      @instance.context
    end

    # def inspect
    # TODO: Redefine to show only useful information
    # super
    # end

    class << self
      attr_accessor :error_store

      # TODO: remove Debug accessors
      attr_reader :squads, :main_flow

      def call(**params)
        instance = new(error_store: error_store.new, **params)
        Decouplio::LogicProcessor.call(flow: @flow, instance: instance)
        # TODO: process block with after actions
        instance
      end

      def call!(**params)
        # TODO: raises an error if instance failed
      end

      private

      def inherited(child_class)
        child_class.error_store = error_store || Decouplio::DefaultErrorHandler

        class << child_class
          alias_method :__new, :new
          def new(**args)
            e = __new(**args)
            compose_logic
            e
          end
        end
      end

      def logic(&block)
        # TODO: raise error if @main flow is not empty, check the case when several logic block are difined
        if block_given?
          @logic = block
        else
          # TODO: rails error if no logic is provided
        end
      end

      def compose_logic
        @flow = Flow.call(logic: @logic, action_class: self)
      end
    end
  end
end
