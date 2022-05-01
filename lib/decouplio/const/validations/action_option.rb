# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module ActionOption
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          %s
          Next options are not allowed for "%s":
          %s

          Details:
          "action" option is not allowed for
            - wrap
            - octo
            - palp
            - resq

          %s
        ERROR_MESSAGE
      end
    end
  end
end
