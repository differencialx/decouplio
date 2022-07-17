# frozen_string_literal: true

module Decouplio
  module Const
    module DobyAideOptions
      ALLOWED = %i[
        on_success
        on_failure
        on_error
        finish_him
        if
        unless
      ].freeze
    end
  end
end
