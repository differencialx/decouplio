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
    step :any_name, action: InnerAction
    # OR
    # fail :any_name, action: InnerAction
    # OR
    # pass :any_name, action: InnerAction
  end
end

action = SomeAction.call

puts action # =>
# Result: success

# Railway Flow:
#   any_name -> step_one -> step_two

# Context:
#   {:step_one=>"Success", :step_two=>"Success"}

# Errors:
#   {}
