module Decouplio
  class Step
    STEP_TYPE = :step
    FAIL_TYPE = :fail
    PASS_TYPE = :pass
    IF_TYPE = :if
    UNLESS_TYPE = :unless
    STRATEGY_TYPE = :strategy

    attr_reader :instance_method, :on_success, :on_failure, :type, :name, :condition
    attr_writer :on_success, :on_failure

    def initialize(
      instance_method:,
      on_success:,
      on_failure:,
      type:,
      condition: nil
    )
      @instance_method = instance_method
      @on_success = on_success
      @on_failure = on_failure
      @type = type
      @condition = condition
    end

    def has_condition?
      @condition
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
      @condition[:type] == IF_TYPE
    end

    def is_unless?
      @condition[:type] == UNLESS_TYPE
    end

    def is_strategy?
      @type == STRATEGY_TYPE
    end

    def is_finish_him?(railway_flow:)
      self.public_send(railway_flow) == :finish_him
    end
  end
end
