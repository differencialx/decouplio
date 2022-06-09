# frozen_string_literal: true

require 'forwardable'
require_relative 'flow'
require_relative 'processor'
require_relative 'default_error_handler'
require_relative 'errors/logic_redefinition_error'
require_relative 'errors/logic_is_not_defined_error'
require_relative 'errors/error_store_error'
require_relative 'errors/execution_error'
require_relative 'const/results'

module Decouplio
  class Action
    PREVIOUS_STEP_INDEX = -2

    extend Forwardable
    def_delegators :@error_store, :errors, :add_error
    attr_reader :railway_flow, :ctx, :error_store

    def initialize(
      parent_railway_flow: nil, parent_ctx: nil, error_store:, **params
    )
      @error_store = error_store
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

    def previous_step
      railway_flow[PREVIOUS_STEP_INDEX]
    end

    def append_railway_flow(stp)
      railway_flow << stp
    end

    def inspect
      <<~INSPECT
        Result: #{success? ? 'success' : 'failure'}

        Railway Flow:
          #{railway_flow.join(' -> ')}

        Context:
          #{ctx.map { |k, v| "#{k.inspect} => #{v.inspect}" }.join("\n  ")}

        Errors:
          #{
            if errors.is_a?(Hash)
              if errors.empty?
                'None'
              else
                errors.map do |k, v|
                  "#{k.inspect} => #{v.inspect}"
                end.join("\n  ")
              end
            else
              errors
            end
          }
      INSPECT
    end

    def to_s
      inspect
    end

    class << self
      attr_accessor :error_store

      def error_store_class(klass)
        self.error_store = klass
      end

      def call(**params)
        instance = new(error_store: error_store.new, **params)
        Decouplio::Processor.call(instance: instance, **@flow)
        # TODO: process block with after actions
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
        child_class.error_store = error_store || Decouplio::DefaultErrorHandler
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
