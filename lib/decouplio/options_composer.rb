require_relative 'step'
require_relative 'options_validator'

module Decouplio
  class OptionsComposer
    class << self
      def call(name:, options:, type:, action_class:, step_names:, wrap_inner_flow: nil)
        validate_options(name: name, type: type, options: options, action_class: action_class, step_names: step_names)

        on_success = options[:on_success]
        on_failure = options[:on_failure]

        error_handlers = nil

        if %i[wrap step].include?(type)
          on_failure ||= :finish_him if options[:finish_him] == :on_failure
          on_success ||= :finish_him if options[:finish_him] == :on_success
        elsif type == :fail
          on_failure ||= :finish_him if options[:finish_him]
        elsif type == :pass
          on_success ||= :finish_him if options[:finish_him]
        elsif type == :resq
          error_handlers = {}

          options.each do |handler_method, error_classes|
            [error_classes].flatten.each do |error_class|
              error_handlers[error_class] = handler_method
            end
          end
        end

        condition_options = compose_condition(options.slice(:if, :unless))

        {
          name: name,
          options: Decouplio::Step.new(
            instance_method: name,
            on_success: on_success,
            on_failure: on_failure,
            type: compose_type(options, type),
            condition: condition_options,
            ctx_key: options[:ctx_key],
            hash_case: options[:hash_case],
            action: options[:action],
            klass: options[:klass],
            method: options[:method],
            wrap_inner_flow: wrap_inner_flow,
            handlers: error_handlers
          )
        }
      end

      private

      def compose_condition(condition_options)
        # raise OnlyIfOrUnlessCanBePresent # Only one of options can be present :if or :unless
        return if condition_options.empty?

        ([[:instance_method, :type]] + condition_options.invert.to_a).transpose.to_h # { instance_method: :some_method, type: : if/unless }
      end

      def validate_options(name:, type:, options:, action_class:, step_names:)
        Decouplio::OptionsValidator.call(name: name, type: type, options: options, action_class: action_class, step_names: step_names)
      end

      def compose_type(options, type)
        if options.has_key?(:action)
          Decouplio::Step::ACTION_TYPE
        else
          type
        end
      end
    end
  end
end
