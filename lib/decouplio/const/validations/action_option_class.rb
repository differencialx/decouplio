# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module ActionOptionClass
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          %s
          Next options are not allowed for "%s":
          %s

          Details:
          "action" allows only classes inherited from Decouplio::Action

          %s
        ERROR_MESSAGE
      end
    end
  end
end
