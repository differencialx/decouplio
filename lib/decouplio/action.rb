# frozen_string_literal: true

module Decouplio
  class Action
    extend Forwardable
    def_delegator :@ctx, :[]

    attr_reader :railway_flow, :ctx, :meta_store
    attr_writer :success

    alias ms meta_store
    alias c ctx

    PASS = true
    FAIL = false

    def initialize(
      meta_store, parent_railway_flow, ctx
    )
      @meta_store = meta_store
      @ctx = ctx
      @railway_flow = parent_railway_flow
      @success = true
    end

    def success?
      @success
    end

    def failure?
      !@success
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

      def call(_parent_meta_store: nil, _parent_railway_flow: nil, _parent_ctx: nil, **params)
        instance = new(
          _parent_meta_store || meta_store.new,
          _parent_railway_flow || [],
          _parent_ctx || Ctx[params]
        )
        next_step = @first_step

        next_step = next_step.process(instance) while next_step
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
        unless @first_step.nil?
          raise Decouplio::Errors::LogicRedefinitionError.new(
            errored_option: to_s
          )
        end
        if block_given?
          @first_step = Decouplio::NewFlow.call(block)

          if @first_step.nil?
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
