# frozen_string_literal: true

require 'active_interaction'
require 'interactor'
require 'mutations'
require 'trailblazer'
require_relative '../lib/decouplio'
require 'pry'
require 'benchmark'
require 'ruby-prof'

class MutationTest < Mutations::Command
  required do
    string :param1
  end

  def execute
    context = {}
    context[:step_one] = param1
    context[:step_two] = context[:step_one]
    context[:step_three] = context[:step_two]
    context[:step_four] = context[:step_three]
    context[:step_five] = context[:step_four]
    context[:step_six] = context[:step_five]
    context[:step_seven] = context[:step_six]
    context[:step_eight] = context[:step_seven]
    context[:step_nine] = context[:step_eight]
  end
end

class ActiveInteractionTest < ActiveInteraction::Base
  string :param1

  def execute
    context = {}
    context[:step_one] = param1
    context[:step_two] = context[:step_one]
    context[:step_three] = context[:step_two]
    context[:step_four] = context[:step_three]
    context[:step_five] = context[:step_four]
    context[:step_six] = context[:step_five]
    context[:step_seven] = context[:step_six]
    context[:step_eight] = context[:step_seven]
    context[:step_nine] = context[:step_eight]
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

class RegularServiceTest
  attr_accessor :ctx, :param1

  def self.call(param1:)
    new(param1: param1).call
  end

  def initialize(param1:)
    @param1 = param1
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
  end

  def step_one
    ctx[:step_one] = param1
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
end

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

iteration_count = 100_000 # rubocop:disable Lint/UselessAssignment

# result = RubyProf.profile do
#   iteration_count.times { InteractorTestOrganizer.call(param1: 'param1') }
# end

# class Two
#   def initialize
#     @ctx = {}
#   end

#   def one
#     @ctx[:one] = 'one'
#   end

#   def two
#     @ctx[:two] = @ctx[:one]
#   end

#   def three
#     @ctx[:three] = @ctx[:two]
#   end
# end

# instance = Two.new

# Benchmark.bmbm do |x|
#   x.report("PublicSend") { iteration_count.times { instance.public_send(:one) } }
#   x.report("Send") { iteration_count.times { instance.send(:one) } }
#   x.report("call instance method") { iteration_count.times { instance.one } }
# end

# array_one = []
# array_two = []

# Benchmark.bmbm do |x|
#   x.report("<<") { iteration_count.times { array_one << 1 } }
#   x.report("push") { iteration_count.times { array_two << 1 } }
# end

# result = RubyProf.profile do
# iteration_count.times { DecouplioTest.call(param1: 'param1') }
# end
# result = RubyProf.profile do
#   iteration_count.times { TrailblazerTest.call(param1: 'param1') }
# end
# result = RubyProf.profile do
#   iteration_count.times { ActiveInteractionTest.run(param1: 'param1') }
# end
# result = RubyProf.profile do
#   iteration_count.times { MutationTest.run(param1: 'param1') }
# end

# printer = RubyProf::GraphPrinter.new(result)
# printer.print(STDOUT, {})

Benchmark.bmbm do |x|
  x.report("RegularService") { iteration_count.times { RegularServiceTest.call(param1: 'param1') } }
  x.report("ActiveInteraction") { iteration_count.times { ActiveInteractionTest.run(param1: 'param1') } }
  x.report("Mutation") { iteration_count.times { MutationTest.run(param1: 'param1') } }
  x.report("Interactor") { iteration_count.times { InteractorTestOrganizer.call(param1: 'param1') } }
  x.report("Trailblazer") { iteration_count.times { TrailblazerTest.call(param1: 'param1') } }
  x.report("Decouplio")  { iteration_count.times { DecouplioTest.call(param1: 'param1') } }
end
