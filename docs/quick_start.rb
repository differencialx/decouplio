require_relative '../lib/decouplio'

class ProcessNumber < Decouplio::Action
  logic do
    step :multiply
    step :divide
  end

  def multiply(number:, multiplier:, **)
    ctx[:result] = number * multiplier
  end

  def divide(result:, divider:, **)
    ctx[:result] = result / divider
  end
end

action = ProcessNumber.call(number: 5, multiplier: 4, divider: 10) # =>
# Result: success

# Railway Flow:
#   multiply -> divide

# Context:
#   {:number=>5, :multiplier=>4, :divider=>10, :result=>2}

# Errors:
#   {}
puts action
puts action[:number]# => 5
puts action[:multiplier]# => 4
puts action[:divider]# => 10
puts action[:result]# => 2

puts action.success? # => true
puts action.failure? # => false

puts action.railway_flow.to_s # => [:multiply, :divide]

# OR
# If action result is failure then Decouplio::Errors::ExecutionError is raised
class RaisingAction < Decouplio::Action
  logic do
    step :step_one
    step :step_two
  end

  def step_one(step_one_param:, **)
    ctx[:step_one] = step_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end
end

begin
  RaisingAction.call!(step_one_param: false)
rescue Decouplio::Errors::ExecutionError => exception
  puts exception.message # => Action failed.
  puts exception.action # =>
  # Result: failure

  # Railway Flow:
  #   step_one

  # Context:
  #   :step_one_param => false
  #   :step_one => false

  # Errors:
  #   None
end
