module Decouplio
  class Step
    STEP_TYPE = :step
    FAIL_TYPE = :fail
    PASS_TYPE = :pass
    IF_TYPE = :if
    UNLESS_TYPE = :unless
    STRATEGY_TYPE = :strategy
    SQUAD_TYPE = :sqaud
    ACTION_TYPE = :action
    WRAP_TYPE = :wrap

    # TODO: review attrs, maybe odd are present
    attr_reader :instance_method, :type, :name, :condition, :hash_case, :action, :on_success, :on_failure, :ctx_key, :logic_container, :steps
    attr_writer :on_success, :on_failure, :hash_case, :condition, :logic_container

    def initialize(
      instance_method: nil,
      on_success: nil,
      on_failure: nil,
      type:,
      ctx_key: nil,
      hash_case: nil,
      condition: nil,
      action: nil,
      logic_container: nil,
      steps: nil,
      resq: nil,
      wrap_block: nil
    )
      @instance_method = instance_method
      @on_success = on_success
      @on_failure = on_failure
      @type = type
      @condition = condition
      @ctx_key = ctx_key
      @hash_case = hash_case
      @action = action
      @logic_container = logic_container
      @steps = steps
      @resq = resq
      @wrap_block = wrap_block
    end

    def has_condition?
      @condition
    end

    def has_resq?
      @resq
    end

    def is_step?
      @type == STEP_TYPE
    end

    def is_fail?
      @type == FAIL_TYPE
    end

    def is_pass?
      @type == PASS_TYPE
    end

    def is_if?
      @type == IF_TYPE
    end

    def is_unless?
      @type == UNLESS_TYPE
    end

    def is_condition?
      is_if? || is_unless?
    end

    def is_strategy?
      @type == STRATEGY_TYPE
    end

    def is_squad?
      @type == SQUAD_TYPE
    end

    def is_action?
      @type == ACTION_TYPE
    end

    def is_step_type?
      is_step? || is_pass? || is_strategy? || is_action?
    end

    def is_fail_type?
      is_fail?
    end

    def is_main_flow?
      is_step_type? || is_fail_type?
    end

    def is_finish_him?(railway_flow:)
      self.public_send(railway_flow) == :finish_him
    end

    def is_fail_with_if?
      is_condition? && @on_success.is_fail?
    end

    # Debag methods

#     def inspect
#       <<-INSPECT

# Success Flow: #{success_flow}
# Failure Flow: #{failure_flow}
# Type: #{type}
#       INSPECT
#     end

    def success_flow
      "#{instance_method} -> #{on_success&.success_flow}"
    end

    def failure_flow
      "#{instance_method} -> #{on_failure&.failure_flow}"
    end
  end
end
