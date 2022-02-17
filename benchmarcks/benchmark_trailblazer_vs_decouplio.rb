require 'trailblazer'
require_relative '../lib/decouplio'
require 'pry'
require 'benchmark'

class TrailblazerTest < Trailblazer::Activity::Railway
  step :step_one
  step :step_two
  step :step_three
  step :step_four
  step :step_five
  step :step_six
  step :step_seven
  step :step_eight
  step :step_nine

  def step_one(ctx, param1:, **)
    ctx[:step_one] = param1
  end

  def step_two(ctx, step_one:, **)
    ctx[:step_two] = step_one
  end

  def step_three(ctx, step_two:, **)
    ctx[:step_three] = step_two
  end

  def step_four(ctx, step_three:, **)
    ctx[:step_four] = step_three
  end

  def step_five(ctx, step_four:, **)
    ctx[:step_five] = step_four
  end

  def step_six(ctx, step_five:, **)
    ctx[:step_six] = step_five
  end

  def step_seven(ctx, step_six:, **)
    ctx[:step_seven] = step_six
  end

  def step_eight(ctx, step_seven:, **)
    ctx[:step_eight] = step_seven
  end

  def step_nine(ctx, step_eight:, **)
    ctx[:step_nine] = step_eight
  end
end

class DecouplioTest < Decouplio::Action
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
  end

  def step_one(param1:, **)
    ctx[:step_one] = param1
  end

  def step_two(step_one:, **)
    ctx[:step_two] = step_one
  end

  def step_three(step_two:, **)
    ctx[:step_three] = step_two
  end

  def step_four(step_three:, **)
    ctx[:step_four] = step_three
  end

  def step_five(step_four:, **)
    ctx[:step_five] = step_four
  end

  def step_six(step_five:, **)
    ctx[:step_six] = step_five
  end

  def step_seven(step_six:, **)
    ctx[:step_seven] = step_six
  end

  def step_eight(step_seven:, **)
    ctx[:step_eight] = step_seven
  end

  def step_nine(step_eight:, **)
    ctx[:step_nine] = step_eight
  end
end

iteration_count = 100_000

Benchmark.bmbm do |x|
  x.report("Trailblazer") { iteration_count.times { TrailblazerTest.call(param1: 'param1') } }
  x.report("Decouplio")  { iteration_count.times { DecouplioTest.call(param1: 'param1') } }
end