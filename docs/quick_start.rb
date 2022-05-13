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
