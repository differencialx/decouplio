# frozen_string_literal: true

class SimplePoro
  def initialize(initial_param)
    @initial_param = initial_param
    @ctx = {}
  end

  def call
    step_one
    step_two
    step_three
    step_four
    step_five
    step_six
    step_seven
    step_eight
    step_nine
    step_ten
  end

  private

  def step_one
    @ctx[:step_one] = @initial_param
  end

  def step_two
    @ctx[:step_two] = @ctx[:step_one]
  end

  def step_three
    @ctx[:step_three] = @ctx[:step_two]
  end

  def step_four
    @ctx[:step_four] = @ctx[:step_three]
  end

  def step_five
    @ctx[:step_five] = @ctx[:step_four]
  end

  def step_six
    @ctx[:step_six] = @ctx[:step_five]
  end

  def step_seven
    @ctx[:step_seven] = @ctx[:step_six]
  end

  def step_eight
    @ctx[:step_eight] = @ctx[:step_seven]
  end

  def step_nine
    @ctx[:step_nine] = @ctx[:step_eight]
  end

  def step_ten
    @ctx[:step_ten] = @ctx[:step_nine]
  end
end

class PoroAssign
  def initialize(ctx, from, to)
    @ctx = ctx
    @from = from
    @to = to
  end

  def call
    @ctx[@to] = @ctx[@from]
  end
end

class PoroCallable
  def initialize(initial_param)
    @ctx = { initial_param: initial_param }
  end

  def call
    PoroAssign.new(@ctx, :initial_param, :step_one).call
    PoroAssign.new(@ctx, :step_one, :step_two).call
    PoroAssign.new(@ctx, :step_two, :step_three).call
    PoroAssign.new(@ctx, :step_three, :step_four).call
    PoroAssign.new(@ctx, :step_four, :step_five).call
    PoroAssign.new(@ctx, :step_five, :step_six).call
    PoroAssign.new(@ctx, :step_six, :step_seven).call
    PoroAssign.new(@ctx, :step_seven, :step_eight).call
    PoroAssign.new(@ctx, :step_eight, :step_nine).call
    PoroAssign.new(@ctx, :step_nine, :step_ten).call
  end
end
