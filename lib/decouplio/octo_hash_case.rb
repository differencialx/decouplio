# frozen_string_literal: true

module Decouplio
  class OctoHashCase
    class << self
      attr_reader :hash_case

      def inherited(subclass)
        subclass.init_hash_case
        super(subclass)
      end

      def init_hash_case
        @hash_case = {}
      end

      def on(octo_case, stp = nil, **options, &block)
        if stp || block_given?
          validate_options(options)
          on_success = options.delete(:on_success)
          on_failure = options.delete(:on_failure)
          on_error = options.delete(:on_error)
          wrap_block = block_given? ? block : proc { step(stp, **options) }
          @hash_case[octo_case] = Decouplio::Steps::Wrap.new(
            octo_case,
            wrap_block,
            on_success,
            on_failure,
            on_error,
            nil
          )
        else
          raise Decouplio::Errors::OctoCaseIsNotDefinedError.new(
            errored_option: "on :#{octo_case}"
          )
        end
      end

      private

      def validate_options(options)
        OctoOptionsValidator.call(options: options)
      end
    end
  end
end
