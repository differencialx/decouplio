# frozen_string_literal: true

module Decouplio
  module Const
    module ReservedMethods
      NAMES = %i[
        \[\]
        inspect
        to_s
        PASS
        FAIL
      ].freeze
    end
  end
end
