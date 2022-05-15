# frozen_string_literal: true

module Decouplio
  module Const
    module ReservedMethods
      NAMES = %i[
        []
        success?
        failure?
        fail_action
        pass_action
        append_railway_flow
        inspect
        to_s
      ].freeze
    end
  end
end
