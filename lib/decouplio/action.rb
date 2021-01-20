# frozen_string_literal: true

require_relative 'errors/step_argument_error'

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
        # raise StepNameIsReservedError [finish_him]

        composed_options = compose_options(options, :step)
        validate_success_step(composed_options)
        mark_success_track(stp)
        @steps[stp] = composed_options
      end

      def fail(stp, **options)
        # raise StepNameIsReservedError
        # raise FailCantBeFirstStepError, "'fail' can't be a first step, please use 'step'"

        composed_options = compose_options(options, :fail)
        validate_failure_step(composed_options)
        mark_failure_track(stp)
        @steps[stp] = composed_options
      end

      def pass(stp, **options)
        # raise StepNameIsReservedError

        composed_options = compose_options(options, :pass)
        validate_success_step(composed_options)
        mark_success_track(stp)
        @steps[stp] = composed_options
      end

      def init_steps
        @steps ||= {}
        @success_track ||= []
        @failure_track ||= {}
      end

      private

      def process_step(stp)
        if stp.is_a?(Symbol)
          process_symbol_step(stp)
        end
      end

      def process_symbol_step(stp)
        result = call_instance_method(stp) || step_type(stp).eql?(:pass)
        @instance.railway_flow << stp

        if result && @instance.success?
          next_step = on_success_step(stp, result) || @success_track.shift

          # handle if:, unless: conditions for steps
          condition = @steps.dig(next_step, :condition)
          if !condition.nil? && !condition.empty?
            # raise IfMethodsShouldBeImplemented, "Please define #{if_condition_method} method inside action" unless @instance.respond_to?(if_condition_method)

            condition_method_result = call_instance_method(condition[:method])
            case condition[:type]
            when :if
              next_step = @success_track.shift unless condition_method_result
            when :unless
              next_step = @success_track.shift if condition_method_result
            end
          end

          process_step(next_step) if can_be_processed_success_track?(stp)
        else
          @instance.fail_action if can_be_failed?(stp)

          next_step = on_failure_step(stp, result) || @failure_track[stp]

          # handle if:, unless: conditions for steps
          condition = @steps.dig(next_step, :condition)
          if !condition.nil? && !condition.empty?
            # raise IfMethodsShouldBeImplemented, "Please define #{if_condition_method} method inside action" unless @instance.respond_to?(if_condition_method)

            condition_method_result = call_instance_method(condition[:method])
            case condition[:type]
            when :if
              next_step = @failure_track[next_step] unless condition_method_result
            when :unless
              next_step = @failure_track[next_step] if condition_method_result
            end
          end

          process_step(next_step) if can_be_processed_failure_track?(stp)
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

      def validate_success_step(options)
        # Validate if only allowed options are present
        # options.each do |key, val|
        #   case key
        #   when :on_success
        #     raise(Decouplio::Errors::StepArgumentError, 'Invalid arguments for step') unless %i[:finish_him].include?(val)
        #     also validate if on_success and failure is a symbols, if it is a inner step than tag should be provided
        #   end
        # end
      end

      def validate_failure_step(options)
        # Validate if only allowed options are present
      end

      def compose_options(options, step_type)
        {
          finish_him: options[:finish_him],
          on_success: options[:on_success],
          on_failure: options[:on_failure],
          condition: compose_condition(options.slice(:if, :unless)),
          squad: options[:squad],
          type: step_type
        }
      end

      def compose_condition(condition_options)
        # raise OnlyIfOrUnlessCanBePresent # Only one of options can be present :if or :unless
        return condition_options if condition_options.empty?

        ([[:method, :type]] + condition_options.invert.to_a).transpose.to_h # { method: :some_method, condition_type: : if/unless }
      end

      def compose_squad(squad_options)
        {}
      end

      def can_be_processed_success_track?(stp)
        return true if @steps[stp].slice(:finish_him, :on_success, :on_failure).values.compact.empty?

        !([true, :on_success].include?(@steps[stp][:finish_him]) ||
          [:finish_him].include?(@steps[stp][:on_success]) ||
          [:finish_him].include?(@steps[stp][:on_failure]))
      end

      def can_be_processed_failure_track?(stp)
        return true if @steps[stp].slice(:finish_him, :on_success, :on_failure).values.compact.empty?


        !([true, :on_failure].include?(@steps[stp][:finish_him]) ||
          [:finish_him].include?(@steps[stp][:on_success]) ||
          [:finish_him].include?(@steps[stp][:on_failure]))
      end

      def can_be_failed?(stp)
        has_no_on_success_failure_logic?(stp) || on_failure_finish_him?(stp) || finish_him_on_failure?(stp)
      end

      def has_no_on_success_failure_logic?(stp)
        @steps[stp].slice(:on_failure, :on_success).values.compact.empty?
      end

      def finish_him_on_failure?(stp)
        [:on_failure, true].include?(@steps.dig(stp, :finish_him))
      end

      def on_failure_finish_him?(stp)
        @steps.dig(stp, :on_failure) == :finish_him
      end

      def on_success_finish_him?(stp)
        @steps.dig(stp, :on_success) == :finish_him
      end

      def on_success_step(stp, result)
        return if on_success_finish_him?(stp)

        on_success_value = @steps.dig(stp, :on_success)
        if on_success_value && result
          clean_up_track(on_success_value) if on_success_value
          on_success_value
        end
      end

      def on_failure_step(stp, result)
        return if on_failure_finish_him?(stp)

        on_failure_value = @steps.dig(stp, :on_failure)
        on_failure_value if on_failure_value && !result
      end

      def clean_up_track(stp)
        case step_type(stp)
        when :step, :pass
          @success_track = @success_track[@success_track.index(stp)+1..-1]
        end
      end

      def step_type(stp)
        @steps.dig(stp, :type)
      end
    end
  end
end
