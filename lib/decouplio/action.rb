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
      def inherited(child_class)
        child_class.init_steps
      end

      def call(**params)
        @instance = new(params)
        process_step(@steps.keys.first)
        @instance
      end

      protected

      def step(stp, **options)
        mark_success_track(stp)
        @steps[stp] = options.merge(type: :step)
      end

      def fail(stp, **options)
        # raise FailCantBeFirstStepError, "'fail' can't be a first step, please use 'step'"

        mark_failure_track(stp)
        @steps[stp] = options.merge(type: :fail)
      end

      def pass(stp, **options)
        @steps[stp] = options.merge(type: :pass)
      end

      def init_steps
        @steps ||= {}
        @success_track ||= []
        @failure_track ||= {}
      end

      private

      def process_step(stp)
        if stp.is_a?(Symbol)
          result = call_instance_method(stp)
          @instance.railway_flow << stp
          if result && @instance.success?
            next_step = @success_track.shift

            if_condition_method = @steps.dig(next_step, :if)
            if if_condition_method
              # raise IfMethodsShouldBeImplemented, "Please define #{if_condition_method} method inside action" unless @instance.respond_to?(if_condition_method)

              unless call_instance_method(if_condition_method)
                next_step = @success_track.shift
              end
            end

            process_step(next_step)
          else
            @instance.fail_action

            next_step = @failure_track[stp]
            if_condition_method = @steps.dig(next_step, :if)
            if if_condition_method
              # raise IfMethodsShouldBeImplemented, "Please define #{if_condition_method} method inside action" unless @instance.respond_to?(if_condition_method)

              unless call_instance_method(if_condition_method)
                next_step = @failure_track[next_step]
              end
            end
            process_step(next_step) if can_be_processed?(stp)
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
