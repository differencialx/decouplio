# Context

Currently context is a simple `Hash` which can be accessed by step methods.

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    step :step_two
  end

  def step_one(**)
    ctx[:step_one] = 'Step one ctx value'
  end

  # step method receives ctx as an argument
  def step_two(step_one:, **)
    ctx[:step_two] = step_one
  end
end

action = SomeAction.call

action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:step_one=>"Step one ctx value", :step_two=>"Step one ctx value"}

# Errors:
#   {}
```

All key values passed into `call` method will be automatically assigned to action context.

```ruby
require 'decouplio'

class SomeActionCtx < Decouplio::Action
  logic do
    step :step_one
  end

  def step_one(**)
    puts ctx
    ctx[:result] = ctx[:one] + ctx[:two]
  end
end

action = SomeActionCtx.call(
  one: 1,
  two: 2
) # =>
# {:one=>1, :two=>2}

action[:result] # => 3

action # =>
# Result: success

# Railway Flow:
#   step_one

# Context:
#   {:one=>1, :two=>2, :result=>3}

# Errors:
#   {}
```
