# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Palp
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          %s
          Details:
          %s
          Please read the manual about allowed options here:
          %s
          %s
        ERROR_MESSAGE

        DOES_NOT_ALLOW_ANY_OPTION = '"palp" does not allow any options'
        MANUAL_URL = 'https://stub.palp.manual.url'
        NOT_DEFINED = 'The palp block is not defined'
      end
    end
  end
end
