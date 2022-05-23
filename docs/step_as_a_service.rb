require_relative '../lib/decouplio'

class Concat
  def self.call(ctx:)
    new(ctx: ctx).call
  end

  def initialize(ctx:)
    @ctx = ctx
  end

  def call
    @ctx[:result] = @ctx[:one] + @ctx[:two]
  end
end

class Subtract
  def self.call(ctx:)
    ctx[:result] = ctx[:one] - ctx[:two]
  end
end

class SomeActionConcat < Decouplio::Action
  logic do
    step Concat
  end
end

action = SomeActionConcat.call(one: 1, two: 2)

puts action[:result] # => 3

puts action # =>
# Result: success

# Railway Flow:
#   Concat

# Context:
#   {:one=>1, :two=>2, :result=>3}

# Errors:
#   {}



class SomeActionSubtract < Decouplio::Action
  logic do
    step :init_one
    step :init_two
    step Subtract
  end

  def init_one(param_one:, **)
    ctx[:one] = param_one
  end

  def init_two(param_two:, **)
    ctx[:two] = param_two
  end
end

action = SomeActionSubtract.call(param_one: 5, param_two: 2)

puts action[:result] # => 3

puts action # =>
# Result: success

# Railway Flow:
#   init_one -> init_two -> Subtract

# Context:
#   {:param_one=>5, :param_two=>2, :one=>5, :two=>2, :result=>3}

# Errors:
#   {}
