# frozen_string_literal: true

# require_relative 'base_step'

module Decouplio
  module Validators
    class Condition
      ONE = 1 # lol

      def self.validate(condition_options:, type:)
        return if condition_options.size == ONE

        case type
        when Decouplio::Const::Types::STEP_TYPE,
             Decouplio::Const::Types::RESQ_TYPE_STEP,
             Decouplio::Const::Types::ACTION_TYPE_STEP
          raise Decouplio::Errors::StepControversialKeysError.new(
            errored_option: condition_options.to_s,
            details: %i[if unless]
          )
        when Decouplio::Const::Types::FAIL_TYPE,
             Decouplio::Const::Types::RESQ_TYPE_FAIL,
             Decouplio::Const::Types::ACTION_TYPE_FAIL
          raise Decouplio::Errors::FailControversialKeysError.new(
            errored_option: condition_options.to_s,
            details: %i[if unless]
          )
        when Decouplio::Const::Types::PASS_TYPE,
             Decouplio::Const::Types::RESQ_TYPE_PASS,
             Decouplio::Const::Types::ACTION_TYPE_PASS
          raise Decouplio::Errors::PassControversialKeysError.new(
            errored_option: condition_options.to_s,
            details: %i[if unless]
          )
        when Decouplio::Const::Types::OCTO_TYPE
          raise Decouplio::Errors::OctoControversialKeysError.new(
            errored_option: condition_options.to_s,
            details: %i[if unless]
          )
        when Decouplio::Const::Types::WRAP_TYPE
          raise Decouplio::Errors::WrapControversialKeysError.new(
            errored_option: condition_options.to_s,
            details: %i[if unless]
          )
        end
      end
    end
  end
end
