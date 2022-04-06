# frozen_string_literal: true

require 'interactor'
require_relative '../lib/decouplio'
require 'pry'
require 'benchmark'

class StepOne
  include Interactor

  def call
    context.step_one = context.param1
  end
end

class StepTwo
  include Interactor

  def call
    context.step_two = context.step_one
  end
end

class StepThree
  include Interactor

  def call
    context.step_three = context.step_two
  end
end

class StepFour
  include Interactor

  def call
    context.step_four = context.step_three
  end
end

class StepFive
  include Interactor

  def call
    context.step_five = context.step_four
  end
end

class StepSix
  include Interactor

  def call
    context.step_six = context.step_five
  end
end

class StepSeven
  include Interactor

  def call
    context.step_seven = context.step_six
  end
end

class StepEight
  include Interactor

  def call
    context.step_eight = context.step_seven
  end
end

class StepNine
  include Interactor

  def call
    context.step_nine = context.step_eight
  end
end

class InteractorTestOrganizer
  include Interactor::Organizer

  organize StepOne,
           StepTwo,
           StepThree,
           StepFour,
           StepFive,
           StepSix,
           StepSeven,
           StepEight,
           StepNine
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

iteration_count = 1_000_00

Benchmark.bmbm do |x|
  x.report('Interactor') { iteration_count.times { InteractorTestOrganizer.call(param1: 'param1') } }
  x.report('Decouplio')  { iteration_count.times { DecouplioTest.call(param1: 'param1') } }
end
