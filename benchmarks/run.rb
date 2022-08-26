# frozen_string_literal: true

require 'bundler/setup'

require 'benchmark/ips'

require_relative 'poro'
require_relative 'decouplio_actions'
require_relative 'interactors'
require_relative 'trailblazer_operations'

initial_param = 'Initial Param'

# poro = SimplePoro.new(initial_param)
# poro.call
# puts poro.inspect

# trb = TrbSimpleSteps.call(initial_param: initial_param)
# puts trb.inspect

# interactor = InteractorStepsService.call(initial_param: initial_param)
# puts interactor.inspect

# decoup = DecouplioSimpleSteps.call(initial_param: initial_param)
# puts decoup

puts 'Simple steps'
Benchmark.ips do |x|
  x.config(stats: :bootstrap, confidence: 95)

  x.report('PORO') { SimplePoro.new(initial_param).call }
  x.report('Trailblazer') { TrbSimpleSteps.call(initial_param: initial_param) }
  x.report('Interactor') { InteractorStepsService.call(initial_param: initial_param) }
  x.report('Decouplio') { DecouplioSimpleSteps.call(initial_param: initial_param) }

  x.compare!
end

# poro = PoroCallable.new(initial_param)
# poro.call
# puts poro.inspect

# trb = TrbWithMacro.call(initial_param: initial_param)
# puts trb.inspect

# interactor = InteractorWithOrganizer.call(initial_param: initial_param)
# puts interactor.inspect

# decoup = DecouplioWithServiceStep.call(initial_param: initial_param)
# puts decoup

puts 'Callable steps'
Benchmark.ips do |x|
  x.config(stats: :bootstrap, confidence: 95)

  x.report('PORO') { PoroCallable.new(initial_param).call }
  x.report('Trailblazer Macro') { TrbWithMacro.call(initial_param: initial_param) }
  x.report('Interactor') { InteractorWithOrganizer.call(initial_param: initial_param) }
  x.report('Decouplio') { DecouplioWithServiceStep.call(initial_param: initial_param) }

  x.compare!
end
