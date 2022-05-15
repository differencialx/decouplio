# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module ActionOptionClass
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          Next options are not allowed for "%s":
          %s

          Details:
          "action" allows only classes inherited from Decouplio::Action
        ERROR_MESSAGE
      end
    end
  end
end
