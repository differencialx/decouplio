# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Action
        VALIDATION_ERROR_MESSAGE = <<~ERROR_MESSAGE
          %s
          The "%s" class has already been defined. Please use different class name.
          %s
        ERROR_MESSAGE
      end
    end
  end
end
