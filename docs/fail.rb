require_relative '../lib/decouplio'



# Behavior
class SomeAction < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end
end

success_action = SomeAction.call(param_for_step_one: true)
failure_action = SomeAction.call(param_for_step_one: false)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one

# Context:
#   {:param_for_step_one=>true}

# Errors:
#   {}


puts failure_action # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two

# Context:
#   {:param_for_step_one=>false, :action_failed=>true, :fail_two=>"Failure"}

# Errors:
#   {}



# on_success: :finish_him
class SomeActionOnSuccessFinishHim < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one, on_success: :finish_him
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(fail_one_param:, **)
    ctx[:action_failed] = fail_one_param
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end
end

success_action = SomeActionOnSuccessFinishHim.call(
  param_for_step_one: true
)
fail_step_success = SomeActionOnSuccessFinishHim.call(
  param_for_step_one: false,
  fail_one_param: true
)
fail_step_failure = SomeActionOnSuccessFinishHim.call(
  param_for_step_one: false,
  fail_one_param: false
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one

# Context:
#   {:param_for_step_one=>true}

# Errors:
#   {}

puts fail_step_success # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true}

# Errors:
#   {}

puts fail_step_failure  # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :fail_two=>"Failure"}

# Errors:
#   {}



# on_success: next success track step
class SomeActionOnSuccessToSuccessTrack < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one, on_success: :step_two
    step :step_two
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(fail_one_param:, **)
    ctx[:action_failed] = fail_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end
end

success_action = SomeActionOnSuccessToSuccessTrack.call(
  param_for_step_one: true
)
fail_step_success = SomeActionOnSuccessToSuccessTrack.call(
  param_for_step_one: false,
  fail_one_param: true
)
fail_step_failure = SomeActionOnSuccessToSuccessTrack.call(
  param_for_step_one: false,
  fail_one_param: false
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:param_for_step_one=>true, :step_two=>"Success"}

# Errors:
#   {}

puts fail_step_success # =>
# Result: success

# Railway Flow:
#   step_one -> fail_one -> step_two

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :step_two=>"Success"}

# Errors:
#   {}

puts fail_step_failure  # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :fail_two=>"Failure"}

# Errors:
#   {}



# on_success: next failure track step
class SomeActionOnSuccessToFailureTrack < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one, on_success: :fail_three
    step :step_two
    fail :fail_two
    fail :fail_three
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(fail_one_param:, **)
    ctx[:action_failed] = fail_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end

  def fail_three(**)
    ctx[:fail_three] = 'Failure'
  end
end

success_action = SomeActionOnSuccessToFailureTrack.call(
  param_for_step_one: true
)
fail_step_success = SomeActionOnSuccessToFailureTrack.call(
  param_for_step_one: false,
  fail_one_param: true
)
fail_step_failure = SomeActionOnSuccessToFailureTrack.call(
  param_for_step_one: false,
  fail_one_param: false
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:param_for_step_one=>true, :step_two=>"Success"}

# Errors:
#   {}


puts fail_step_success # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_three

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :fail_three=>"Failure"}

# Errors:
#   {}


puts fail_step_failure  # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two -> fail_three

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :fail_two=>"Failure", :fail_three=>"Failure"}

# Errors:
#   {}



# on_failure: :finish_him
class SomeActionOnFailureFinishHim < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one, on_failure: :finish_him
    step :step_two
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(fail_one_param:, **)
    ctx[:action_failed] = fail_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end
end

success_action = SomeActionOnFailureFinishHim.call(
  param_for_step_one: true
)
fail_step_success = SomeActionOnFailureFinishHim.call(
  param_for_step_one: false,
  fail_one_param: true
)
fail_step_failure = SomeActionOnFailureFinishHim.call(
  param_for_step_one: false,
  fail_one_param: false
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:param_for_step_one=>true, :step_two=>"Success"}

# Errors:
#   {}


puts fail_step_success # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :fail_two=>"Failure"}

# Errors:
#   {}


puts fail_step_failure  # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false}

# Errors:
#   {}



# on_failure: next success track step
class SomeActionOnFailureToSuccessTrack < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one, on_failure: :step_two
    step :step_two
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(fail_one_param:, **)
    ctx[:action_failed] = fail_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end
end

success_action = SomeActionOnFailureToSuccessTrack.call(
  param_for_step_one: true
)
fail_step_success = SomeActionOnFailureToSuccessTrack.call(
  param_for_step_one: false,
  fail_one_param: true
)
fail_step_failure = SomeActionOnFailureToSuccessTrack.call(
  param_for_step_one: false,
  fail_one_param: false
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:param_for_step_one=>true, :step_two=>"Success"}

# Errors:
#   {}

puts fail_step_success # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :fail_two=>"Failure"}

# Errors:
#   {}


puts fail_step_failure  # =>
# Result: success

# Railway Flow:
#   step_one -> fail_one -> step_two

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :step_two=>"Success"}

# Errors:
#   {}



# on_failure: next failure track step
class SomeActionOnFailureToFailureTrack < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one, on_failure: :fail_three
    step :step_two
    fail :fail_two
    fail :fail_three
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(fail_one_param:, **)
    ctx[:action_failed] = fail_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end

  def fail_three(**)
    ctx[:fail_three] = 'Failure'
  end
end

success_action = SomeActionOnFailureToFailureTrack.call(
  param_for_step_one: true
)
fail_step_success = SomeActionOnFailureToFailureTrack.call(
  param_for_step_one: false,
  fail_one_param: true
)
fail_step_failure = SomeActionOnFailureToFailureTrack.call(
  param_for_step_one: false,
  fail_one_param: false
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:param_for_step_one=>true, :step_two=>"Success"}

# Errors:
#   {}
puts fail_step_success # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two -> fail_three

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :fail_two=>"Failure", :fail_three=>"Failure"}

# Errors:
#   {}
puts fail_step_failure  # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_three

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :fail_three=>"Failure"}

# Errors:
#   {}



# if: condition method name
class SomeActionOnIfCondition < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
    step :step_two
    fail :fail_two, if: :some_condition?
    fail :fail_three
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end

  def fail_three(**)
    ctx[:fail_three] = 'Failure'
  end

  def some_condition?(if_condition_param:, **)
    if_condition_param
  end
end

success_action = SomeActionOnIfCondition.call(
  param_for_step_one: true
)
fail_condition_positive = SomeActionOnIfCondition.call(
  param_for_step_one: false,
  if_condition_param: true
)
fail_condition_negative = SomeActionOnIfCondition.call(
  param_for_step_one: false,
  if_condition_param: false
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:param_for_step_one=>true, :step_two=>"Success"}

# Errors:
#   {}

puts fail_condition_positive # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two -> fail_three

# Context:
#   {:param_for_step_one=>false, :if_condition_param=>true, :action_failed=>true, :fail_two=>"Failure", :fail_three=>"Failure"}

# Errors:
#   {}

puts fail_condition_negative  # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_three

# Context:
#   {:param_for_step_one=>false, :if_condition_param=>false, :action_failed=>true, :fail_three=>"Failure"}

# Errors:
#   {}



# unless: condition method name
class SomeActionOnUnlessCondition < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
    step :step_two
    fail :fail_two, unless: :some_condition?
    fail :fail_three
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end

  def fail_three(**)
    ctx[:fail_three] = 'Failure'
  end

  def some_condition?(if_condition_param:, **)
    if_condition_param
  end
end

success_action = SomeActionOnUnlessCondition.call(
  param_for_step_one: true
)
fail_condition_positive = SomeActionOnUnlessCondition.call(
  param_for_step_one: false,
  if_condition_param: false
)
fail_condition_negative = SomeActionOnUnlessCondition.call(
  param_for_step_one: false,
  if_condition_param: true
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:param_for_step_one=>true, :step_two=>"Success"}

# Errors:
#   {}

puts fail_condition_positive # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_two -> fail_three

# Context:
#   {:param_for_step_one=>false, :if_condition_param=>false, :action_failed=>true, :fail_two=>"Failure", :fail_three=>"Failure"}

# Errors:
#   {}

puts fail_condition_negative  # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one -> fail_three

# Context:
#   {:param_for_step_one=>false, :if_condition_param=>true, :action_failed=>true, :fail_three=>"Failure"}

# Errors:
#   {}



# finish_him: true
class SomeActionFinishHimTrue < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one, finish_him: true
    step :step_two
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(fail_one_param:, **)
    ctx[:action_failed] = fail_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end
end

success_action = SomeActionFinishHimTrue.call(
  param_for_step_one: true
)
fail_step_success = SomeActionFinishHimTrue.call(
  param_for_step_one: false,
  fail_one_param: true
)
fail_step_failure = SomeActionFinishHimTrue.call(
  param_for_step_one: false,
  fail_one_param: false
)

puts success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {:param_for_step_one=>true, :step_two=>"Success"}

# Errors:
#   {}

puts fail_step_success # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true}

# Errors:
#   {}

puts fail_step_failure  # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one

# Context:
#   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false}

# Errors:
#   {}
