require 'decouplio'

class DecouplioSimpleSteps < Decouplio::Action
  logic do
    step :step_one
    step :step_two
    step :step_three
    step :step_four
    step :step_five
    step :step_six
    step :step_seven
    step :step_eight
    step :step_nine
    step :step_ten
  end

  def step_one
    ctx[:step_one] = ctx[:initial_param]
  end

  def step_two
    ctx[:step_two] = ctx[:step_one]
  end

  def step_three
    ctx[:step_three] = ctx[:step_two]
  end

  def step_four
    ctx[:step_four] = ctx[:step_three]
  end

  def step_five
    ctx[:step_five] = ctx[:step_four]
  end

  def step_six
    ctx[:step_six] = ctx[:step_five]
  end

  def step_seven
    ctx[:step_seven] = ctx[:step_six]
  end

  def step_eight
    ctx[:step_eight] = ctx[:step_seven]
  end

  def step_nine
    ctx[:step_nine] = ctx[:step_eight]
  end

  def step_ten
    ctx[:step_ten] = ctx[:step_nine]
  end
end

class DecouplioService
  def self.call(ctx, ms, from:, to:)
    ctx[to] = ctx[from]
  end
end

class DecouplioWithServiceStep < Decouplio::Action
  logic do
    step DecouplioService, from: :initial_param, to: :step_one
    step DecouplioService, from: :step_one, to: :step_two
    step DecouplioService, from: :step_two, to: :step_three
    step DecouplioService, from: :step_three, to: :step_four
    step DecouplioService, from: :step_four, to: :step_five
    step DecouplioService, from: :step_five, to: :step_six
    step DecouplioService, from: :step_six, to: :step_seven
    step DecouplioService, from: :step_seven, to: :step_eight
    step DecouplioService, from: :step_eight, to: :step_nine
    step DecouplioService, from: :step_nine, to: :step_ten
  end
end
