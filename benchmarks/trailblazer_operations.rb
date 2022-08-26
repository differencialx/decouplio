# frozen_string_literal: true

require 'trailblazer'

class TrbSimpleSteps < Trailblazer::Operation
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

  def step_one(ctx, **)
    ctx[:step_one] = ctx[:initial_param]
  end

  def step_two(ctx, **)
    ctx[:step_two] = ctx[:step_one]
  end

  def step_three(ctx, **)
    ctx[:step_three] = ctx[:step_two]
  end

  def step_four(ctx, **)
    ctx[:step_four] = ctx[:step_three]
  end

  def step_five(ctx, **)
    ctx[:step_five] = ctx[:step_four]
  end

  def step_six(ctx, **)
    ctx[:step_six] = ctx[:step_five]
  end

  def step_seven(ctx, **)
    ctx[:step_seven] = ctx[:step_six]
  end

  def step_eight(ctx, **)
    ctx[:step_eight] = ctx[:step_seven]
  end

  def step_nine(ctx, **)
    ctx[:step_nine] = ctx[:step_seven]
  end

  def step_ten(ctx, **)
    ctx[:step_ten] = ctx[:step_nine]
  end
end

module Tools
  def self.AssignFromTo(from:, to:)
    id = :"AssignFromTo.#{from}#{to}"
    step = lambda do |ctx, **|
      ctx[to] = ctx[from]
      true
    end
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: id }
  end
end

class TrbWithMacro < Trailblazer::Operation
  step Tools::AssignFromTo from: :initial_param, to: :step_one
  step Tools::AssignFromTo from: :step_one, to: :step_two
  step Tools::AssignFromTo from: :step_two, to: :step_three
  step Tools::AssignFromTo from: :step_three, to: :step_four
  step Tools::AssignFromTo from: :step_four, to: :step_five
  step Tools::AssignFromTo from: :step_five, to: :step_six
  step Tools::AssignFromTo from: :step_six, to: :step_seven
  step Tools::AssignFromTo from: :step_seven, to: :step_eight
  step Tools::AssignFromTo from: :step_eight, to: :step_nine
  step Tools::AssignFromTo from: :step_nine, to: :step_ten
end
