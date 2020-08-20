# frozen_string_literal: true

module Decouplio
  class Action
    attr_reader :errors, :ctx, :railway_flow

    def initialize(parent_instance: nil, wrapper: false, **params)
      @errors = {}
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

    def add_error(key, message)
      errors.store(key, [message].flatten)
    end

    def fail_action
      @failure = true
    end

    class << self
      def call(**params)
        @instance = new(params)
        process_step(@steps.keys.first)
        @instance
      end

      def step(stp, **options)
        init_steps
        mark_success_track(stp)
        @steps[stp] = options.merge(type: :step)
      end

      def fail(stp, **options)
        # raise FailCantBeFirstStepError, "'fail' can't be a first step, please use 'step'"

        init_steps
        mark_failure_track(stp)
        @steps[stp] = options.merge(type: :fail)
      end

      def pass(stp, **options)
        init_steps
        @steps[stp] = options.merge(type: :pass)
      end

      private

      def init_steps
        @steps ||= {}
        @success_track ||= []
        @failure_track ||= {}
      end

      def process_step(stp)
        if stp.is_a?(Symbol)
          result = call_instance_method(stp)
          @instance.railway_flow << stp
          if result && @instance.success?
            process_step(@success_track.shift)
          else
            @instance.fail_action
            process_step(@failure_track[stp]) if can_be_processed?(stp)
          end
        end
      end

      def call_instance_method(stp)
        @instance.public_send(stp, **@instance.ctx)
      end

      def mark_failure_track(failure_stp)
        return if @steps.empty?

        @steps.reverse_each do |stp, step_options|
          if step_options[:type] == :step
            @failure_track[stp] ||= failure_stp
          elsif step_options[:type] == :fail
            @failure_track[stp] ||= failure_stp
          end
        end
      end

      def mark_success_track(success_stp)
        return if @steps.empty?

        @steps.reverse_each do |stp, step_options|
          if step_options[:type] == :step
            @success_track << success_stp && return
          end
        end
      end

      def can_be_processed?(stp)
        !@steps[stp][:finish_him]
      end
    end
  end
end
