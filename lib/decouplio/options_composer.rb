require_relative 'step'

module Decouplio
  class OptionsComposer
    class << self
      def call(name:, options:, type:)
        on_success = options[:on_success]
        on_failure = options[:on_failure]

        if type == :step
          on_failure ||= :finish_him if options[:finish_him] == :on_failure
          on_success ||= :finish_him if options[:finish_him] == :on_success
        elsif type == :fail
          on_failure ||= :finish_him if options.has_key?(:finish_him)
        end

        condition_options = compose_condition(options.slice(:if, :unless))

        {
          name: name,
          options: Decouplio::Step.new(
            instance_method: name,
            on_success: on_success,
            on_failure: on_failure,
            type: type,
            condition: condition_options,
            ctx_key: options[:ctx_key],
            hash_case: options[:hash_case]
          )
        }
      end

      private

      def compose_condition(condition_options)
        # raise OnlyIfOrUnlessCanBePresent # Only one of options can be present :if or :unless
        return if condition_options.empty?

        ([[:instance_method, :type]] + condition_options.invert.to_a).transpose.to_h # { instance_method: :some_method, type: : if/unless }
      end
    end
  end
end
