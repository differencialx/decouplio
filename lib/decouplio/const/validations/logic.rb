# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Logic
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          %s
          %s
          %s
        ERROR_MESSAGE
        REDEFINITION = 'The logic for "%s" class has already been defined.'
        NOT_DEFINED = 'The logic for "%s" class is not define'
      end
    end
  end
end
