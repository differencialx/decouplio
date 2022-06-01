# frozen_string_literal: true

require_relative 'results'

module Decouplio
  module Const
    module ReservedMethods
      NAMES = [
        :[],
        :success?,
        :failure?,
        :fail_action,
        :pass_action,
        :append_railway_flow,
        :inspect,
        :to_s,
        Decouplio::Const::Results::STEP_PASS,
        Decouplio::Const::Results::STEP_FAIL
      ].freeze
    end
  end
end
