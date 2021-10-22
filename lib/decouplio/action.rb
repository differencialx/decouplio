# frozen_string_literal: true

require 'pry'
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
      @strict_squad_mode = false
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

    class << self
      attr_accessor :error_store

      def inherited(child_class)
        child_class.error_store = self.error_store || Decouplio::DefaultErrorHandler.new
        child_class.init_steps
      end

      def call(**params)
        instance = new(error_store: error_store, **params)
        process_step(@steps.keys.first, instance)
        instance
      end

      protected

      def error_store_instance(handler_class)
        self.error_store = handler_class
      end

      def init_steps
        @steps = {}
        @squads = {}
      end

      private

      #
      # option - may contain { on_success:, on_failure:, squad:, if:, unless: }
      # stp - step symbol
      def step(stp, **options)
        if stp.is_a?(Symbol)
          # raise StepMethodIsNotDefined unless self.instance_public_methods.include?(stp)
        end
        # raise StepNameIsReserved [finish_him, on_success, on_failure, squad, if, unless]

        # validate_success_step(options)
        composed_options = compose_options(options, :step)
        mark_success_track(stp)
        mark_squad_track(stp, composed_options)
        mark_last_squad_step(composed_options[:squad], stp)
        @steps[stp] = composed_options
      end

      def fail(stp, **options)
        # raise StepNameIsReservedError
        # raise FailCantBeFirstStepError, "'fail' can't be a first step, please use 'step'"

        composed_options = compose_options(options, :fail)
        # validate_failure_step(composed_options)
        mark_failure_track(stp)
        mark_squad_track(stp, composed_options)
        mark_last_squad_step(composed_options[:squad], stp)
        @steps[stp] = composed_options
      end

      def pass(stp, **options)
        # raise StepNameIsReservedError

        composed_options = compose_options(options, :pass)
        # validate_success_step(composed_options)
        mark_success_track(stp)
        mark_squad_track(stp, composed_options)
        mark_last_squad_step(composed_options[:squad], stp)
        @steps[stp] = composed_options
      end

      def validate_success_step(options)
        # validate if step is not called as squad
      end

      def compose_options(options, step_type)
        on_success = options[:on_success]
        on_failure = options[:on_failure]

        # binding.pry
        if on_success.is_a?(Hash)
          @squads[on_success[:squad]] = { strict: on_success[:strict] }
          on_success = on_success[:squad]
        end
        if on_failure.is_a?(Hash)
          @squads[on_failure[:squad]] = { strict: on_failure[:strict] }
          on_failure = on_failure[:squad]
        end

        if step_type == :step
          on_failure ||= :finish_him if options[:finish_him] == :on_failure
          on_success ||= :finish_him if options[:finish_him] == :on_success
        elsif step_type == :fail
          on_failure ||= :finish_him if options.has_key?(:finish_him)
        end

        {
          on_success: on_success,
          on_failure: on_failure,
          condition: compose_condition(options.slice(:if, :unless)),
          squad: [options[:squad]].flatten.compact,
          type: step_type
        }
      end

      def process_step(stp, instance, last_squad_step_processed = false)
        return unless @steps.has_key?(stp)

        if stp.is_a?(Symbol)
          process_symbol_step(stp, instance, last_squad_step_processed)
        end
      end

      def process_symbol_step(stp, instance, last_squad_step_processed)
        if step_can_be_processed?(stp, instance)
          result = call_instance_method(instance, stp) || step_type(stp).eql?(:pass)
          instance.railway_flow << stp

          case @steps.dig(stp, :type)
          when :step, :pass
            if result && instance.success?
              next_step = obtain_next_success_step(stp)
              success_of_failure_way = :on_success
            else
              next_step = obtain_next_failure_step(stp)
              success_of_failure_way = :on_failure
              instance.fail_action if step_finish_him?(stp, success_of_failure_way)
            end
          when :fail
            next_step = obtain_next_failure_step(stp)
            success_of_failure_way = :on_failure
            instance.fail_action
          end

          binding.pry
          unless step_finish_him?(stp, success_of_failure_way) || last_squad_step_processed
            process_step(next_step, instance, final_squad_step?(stp))
          end

        else
          process_step(
            if @steps[stp][:type].eql?(:fail)
              obtain_next_failure_step(stp)
            elsif %i[step pass].include?(@steps[stp][:type])
              obtain_next_success_step(stp)
            end,
            instance
          )
        end
      end

      def step_finish_him?(stp, success_or_failure_way)
        @steps.dig(stp, success_or_failure_way).eql?(:finish_him)
      end

      def final_squad_step?(stp)
        squads = @steps[stp][:squad]

        return if squads.empty?

        last_steps = @squads.fetch_values(*squads).map { |squad_options| squad_options[:last_step] }.uniq.compact

        last_steps.include?(stp)
      end

      def obtain_next_success_step(stp)
        @steps[stp][:on_success]
      end

      def obtain_next_failure_step(stp)
        @steps[stp][:on_failure]
      end

      def step_can_be_processed?(stp, instance)
        condition = @steps[stp][:condition]

        return true if condition.nil?

        result = call_instance_method(instance, condition[:method])

        condition[:type] == :if ? result : !result
      end

      def call_instance_method(instance, stp)
        instance.public_send(stp, **instance.ctx)
      end

      def mark_success_track(success_stp)
        return if @steps.empty?

        @steps.reverse_each do |stp, step_options|
          next if step_options[:type] == :fail

          if %i[step pass].include?(step_options[:type])
            @steps[stp][:on_success] ||= success_stp
          else
            return
          end
        end
      end

      def mark_failure_track(failure_stp)
        return if @steps.empty?

        @steps.reverse_each do |stp, step_options|
          if %i[step fail].include?(step_options[:type])
            @steps[stp][:on_failure] ||= failure_stp
          end
        end
      end

      def mark_squad_track(stp, composed_options)
        return if composed_options[:squad].empty?

        binding.pry if stp = :step_seven
        @steps.reverse_each do |defined_step, step_options|
          if composed_options[:squad].include?(step_options[:on_success])
            @steps[defined_step][:on_success] = stp
          elsif composed_options[:squad].include?(step_options[:on_failure])
            @steps[defined_step][:on_failure] = stp
          end
        end
      end

      def mark_last_squad_step(squads, stp)
        return if squads.empty?

        squads.each do |squad|
          @squads[squad][:last_step] = stp
        end
      end

      def compose_condition(condition_options)
        # raise OnlyIfOrUnlessCanBePresent # Only one of options can be present :if or :unless
        return if condition_options.empty?

        ([[:method, :type]] + condition_options.invert.to_a).transpose.to_h # { method: :some_method, type: : if/unless }
      end

      def step_type(stp)
        @steps.dig(stp, :type)
      end
    end
  end
end
