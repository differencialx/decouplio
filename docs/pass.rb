require_relative '../lib/decouplio'

# Behavior
class SomeAction < Decouplio::Action
  logic do
    pass :pass_one
    step :step_two
    fail :fail_one
  end

  def pass_one(param_for_pass:, **)
    ctx[:pass_one] = param_for_pass
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_one(**)
    ctx[:fail_one] = 'Failure'
  end
end

pass_success = SomeAction.call(param_for_pass: true)
pass_failure = SomeAction.call(param_for_pass: false)

puts pass_success # =>
# Result: success

# Railway Flow:
#   pass_one -> step_two

# Context:
#   {:param_for_pass=>true, :pass_one=>true, :step_two=>"Success"}

# Errors:
#   {}

puts pass_failure # =>
# Result: success

# Railway Flow:
#   pass_one -> step_two

# Context:
#   {:param_for_pass=>false, :pass_one=>false, :step_two=>"Success"}

# Errors:
#   {}



# if: condition method name
class SomeActionIfCondition < Decouplio::Action
  logic do
    step :step_one
    pass :pass_one, if: :some_condition?
    step :step_two
  end

  def step_one(**)
    ctx[:step_one] = 'Success'
  end

  def pass_one(**)
    ctx[:pass_one] = 'Success'
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def some_condition?(condition_param:, **)
    condition_param
  end
end

condition_positive = SomeActionIfCondition.call(condition_param: true)
condition_negative = SomeActionIfCondition.call(condition_param: false)

puts condition_positive # =>
# Result: success

# Railway Flow:
#   step_one -> pass_one -> step_two

# Context:
#   {:condition_param=>true, :step_one=>"Success", :pass_one=>"Success", :step_two=>"Success"}

# Errors:
#   {}


puts condition_negative # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:condition_param=>false, :step_one=>"Success", :step_two=>"Success"}

# Errors:
#   {}



# unless: condition method name
class SomeActionUnlessCondition < Decouplio::Action
  logic do
    step :step_one
    pass :pass_one, unless: :some_condition?
    step :step_two
  end

  def step_one(**)
    ctx[:step_one] = 'Success'
  end

  def pass_one(**)
    ctx[:pass_one] = 'Success'
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def some_condition?(condition_param:, **)
    condition_param
  end
end

condition_positive = SomeActionUnlessCondition.call(condition_param: false)
condition_negative = SomeActionUnlessCondition.call(condition_param: true)

puts condition_positive # =>
# Result: success

# Railway Flow:
#   step_one -> pass_one -> step_two

# Context:
#   {:condition_param=>false, :step_one=>"Success", :pass_one=>"Success", :step_two=>"Success"}

# Errors:
#   {}

puts condition_negative # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:condition_param=>true, :step_one=>"Success", :step_two=>"Success"}

# Errors:
#   {}



# finish_him: true
class SomeActionFinishHim < Decouplio::Action
  logic do
    step :step_one, on_success: :step_two, on_failure: :pass_one
    pass :pass_one, finish_him: true
    step :step_two
    step :step_three
  end

  def step_one(param_for_step:, **)
    ctx[:step_one] = param_for_step
  end

  def pass_one(**)
    ctx[:pass_one] = 'Success'
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def step_three(**)
    ctx[:step_three] = 'Success'
  end
end

success_track = SomeActionFinishHim.call(param_for_step: true)
failure_track = SomeActionFinishHim.call(param_for_step: false)

puts success_track # =>
# Result: success

# Railway Flow:
#   step_one -> step_two -> step_three

# Context:
#   {:param_for_step=>true, :step_one=>true, :step_two=>"Success", :step_three=>"Success"}

# Errors:
#   {}

puts failure_track # =>
# Result: success

# Railway Flow:
#   step_one -> pass_one

# Context:
#   {:param_for_step=>false, :step_one=>false, :pass_one=>"Success"}

# Errors:
#   {}
