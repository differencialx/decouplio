# frozen_string_literal: true

module Decouplio
  module Const
    module Types
      STEP_TYPE = :step
      FAIL_TYPE = :fail
      PASS_TYPE = :pass
      IF_TYPE = :if
      UNLESS_TYPE = :unless
      OCTO_TYPE = :octo
      WRAP_TYPE = :wrap
      RESQ_TYPE = :resq

      MAIN_FLOW_TYPES = [
        STEP_TYPE,
        FAIL_TYPE,
        PASS_TYPE,
        WRAP_TYPE
      ].freeze
    end
  end
end
