# frozen_string_literal: true

require 'active_interaction'
require 'interactor'
require 'mutations'
require 'trailblazer'
require 'decouplio'
require 'benchmark'

class MutationTest < Mutations::Command
  optional do
    string :param1
  end

  def execute
    @context = {}
    @context[:step_one] = param1
    @context[:step_two] = @context[:step_one]
    @context[:step_three] = @context[:step_two]
    @context[:step_four] = @context[:step_three]
    @context[:step_five] = @context[:step_four]
    @context[:step_six] = @context[:step_five]
    @context[:step_seven] = @context[:step_six]
    @context[:step_eight] = @context[:step_seven]
    @context[:step_nine] = @context[:step_eight]

    @context
  end
end

class ActiveInteractionTest < ActiveInteraction::Base
  string :param1

  def execute
    @context = {}
    @context[:step_one] = param1
    @context[:step_two] = @context[:step_one]
    @context[:step_three] = @context[:step_two]
    @context[:step_four] = @context[:step_three]
    @context[:step_five] = @context[:step_four]
    @context[:step_six] = @context[:step_five]
    @context[:step_seven] = @context[:step_six]
    @context[:step_eight] = @context[:step_seven]
    @context[:step_nine] = @context[:step_eight]

    @context
  end
end

class DecouplioTestOneStep < Decouplio::Action
  logic do
    step :step_one
  end

  def step_one(param1:, **)
    ctx[:step_one] = param1
    ctx[:step_two] = ctx[:step_one]
    ctx[:step_three] = ctx[:step_two]
    ctx[:step_four] = ctx[:step_three]
    ctx[:step_five] = ctx[:step_four]
    ctx[:step_six] = ctx[:step_five]
    ctx[:step_seven] = ctx[:step_six]
    ctx[:step_eight] = ctx[:step_seven]
    ctx[:step_nine] = ctx[:step_eight]
  end
end

class InteractorWithoutOrganizer
  include Interactor

  def call
    context.step_one = context.param1
    context.step_two = context.step_one
    context.step_three = context.step_two
    context.step_four = context.step_three
    context.step_five = context.step_four
    context.step_six = context.step_five
    context.step_seven = context.step_six
    context.step_eight = context.step_seven
    context.step_nine = context.step_eight
  end
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
    ctx[:step_one] = param1
    ctx[:step_two] = ctx[:step_one]
    ctx[:step_three] = ctx[:step_two]
    ctx[:step_four] = ctx[:step_three]
    ctx[:step_five] = ctx[:step_four]
    ctx[:step_six] = ctx[:step_five]
    ctx[:step_seven] = ctx[:step_six]
    ctx[:step_eight] = ctx[:step_seven]
    ctx[:step_nine] = ctx[:step_eight]
  end
end

class TrailblazerTestOneStep < Trailblazer::Activity::Railway
  step :step_one

  def step_one(ctx, param1:, **)
    ctx[:step_one] = param1
    ctx[:step_two] = ctx[:step_one]
    ctx[:step_three] = ctx[:step_two]
    ctx[:step_four] = ctx[:step_three]
    ctx[:step_five] = ctx[:step_four]
    ctx[:step_six] = ctx[:step_five]
    ctx[:step_seven] = ctx[:step_six]
    ctx[:step_eight] = ctx[:step_seven]
    ctx[:step_nine] = ctx[:step_eight]
  end
end

class ServiceAsStep
  def self.call(ctx:)
    ctx[:step_one] = ctx[:param1]
    ctx[:step_two] = ctx[:step_one]
    ctx[:step_three] = ctx[:step_two]
    ctx[:step_four] = ctx[:step_three]
    ctx[:step_five] = ctx[:step_four]
    ctx[:step_six] = ctx[:step_five]
    ctx[:step_seven] = ctx[:step_six]
    ctx[:step_eight] = ctx[:step_seven]
    ctx[:step_nine] = ctx[:step_eight]
  end
end

class DecouplioTestOneStepAsService < Decouplio::Action
  logic do
    step ServiceAsStep
  end
end

iteration_count = 100_000

Benchmark.bmbm do |x|
  x.report('Mutation') { iteration_count.times { MutationTest.run(param1: 'param1') } }
  x.report('ActiveInteraction') { iteration_count.times { ActiveInteractionTest.run(param1: 'param1') } }
  x.report('Trailblazer one step') { iteration_count.times { TrailblazerTestOneStep.call(param1: 'param1') } }
  x.report('Interactor one interactor') { iteration_count.times { InteractorWithoutOrganizer.call(param1: 'param1') } }
  x.report('RegularService') { iteration_count.times { RegularServiceTest.call(param1: 'param1') } }
  x.report('Decouplio one step') { iteration_count.times { DecouplioTestOneStep.call(param1: 'param1') } }
  x.report('Decouplio one step as service') do
    iteration_count.times { DecouplioTestOneStepAsService.call(param1: 'param1') }
  end
end
