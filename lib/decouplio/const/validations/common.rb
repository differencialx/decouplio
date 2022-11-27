# frozen_string_literal: true

module Decouplio
  module Const
    module Validations
      module Common
        WRONG_FINISH_HIM_VALUE = '"finish_him" does not allow "%s" value'
        METHOD_IS_NOT_DEFINED = 'Method "%s" is not defined'
        STEP_IS_NOT_DEFINED = 'Step "%s" is not defined'
        STEP_NAME = '"%s" method is reserved by Decouplio, please another name.'
        STEP_DEFINITION = <<~MESSAGE
          %s is invalid attribute for step

          Allowed values:
          <symbol>
          OR
          <class inherited from Decouplio::Action>
          OR
          <class with implemented self.call(ctx, ms, **) method>
        MESSAGE
      end
    end
  end
end
