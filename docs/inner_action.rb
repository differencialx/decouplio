require_relative '../lib/decouplio'

class InnerAction < Decouplio::Action
  logic do
    step :step_one
    step :step_two
  end

  def step_one(**)
    ctx # => ctx from parent action(SomeAction)
    ctx[:step_one] = 'Success'
  end

  def step_two(**)
    ctx # => ctx from parent action(SomeAction)
    ctx[:step_two] = 'Success'
  end
end


class SomeAction < Decouplio::Action
  logic do
    step InnerAction
    # OR
    # fail InnerAction
    # OR
    # pass InnerAction
  end
end

action = SomeAction.call

puts action # =>
# Result: success

# Railway Flow:
#   InnerAction -> step_one -> step_two

# Context:
#   {:step_one=>"Success", :step_two=>"Success"}

# Errors:
#   {}
