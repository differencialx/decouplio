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
      end
    end
  end
end
