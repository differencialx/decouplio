require_relative '../lib/decouplio'


# Palp

class SomeAction < Decouplio::Action
  logic do
    # it doesn't matter where you define palp
    # at the beginning of logic block
    # or at the end or in the middle
    palp :option_one_palp do
      step :step_one, on_failure: :final_step
      step :step_two
    end

    palp :option_two_palp do
      step :step_two
      step :step_three
    end

    palp :option_three_palp do
      step :step_three
      step :step_one
      fail :fail_one
    end

    step :init_step

    octo :my_octo, ctx_key: :custom_key do
      on :option_one, palp: :option_one_palp
      on :option_two, palp: :option_two_palp
      on :option_three, palp: :option_three_palp
    end

    step :final_step
    fail :fail_two
  end

  def init_step(octo_key:, **)
    ctx[:custom_key] = octo_key
  end

  def step_one(param_for_step_one:, **)
    ctx[:step_one] = param_for_step_one
  end

  def step_two(param_for_step_two:, **)
    ctx[:step_two] = param_for_step_two
  end

  def step_three(param_for_step_three:, **)
    ctx[:step_three] = param_for_step_three
  end

  def fail_one(**)
    ctx[:fail_one] = 'Failure'
  end

  def final_step(**)
    ctx[:final_step] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end
end


octo_option_one_success = SomeAction.call(
  octo_key: :option_one,
  param_for_step_one: true,
  param_for_step_two: true
)
octo_option_one_failure = SomeAction.call(
  octo_key: :option_one,
  param_for_step_one: false,
  param_for_step_two: true
)
octo_option_two_success = SomeAction.call(
  octo_key: :option_two,
  param_for_step_two: true,
  param_for_step_three: true
)
octo_option_two_failure = SomeAction.call(
  octo_key: :option_two,
  param_for_step_two: true,
  param_for_step_three: false
)
octo_option_three_success = SomeAction.call(
  octo_key: :option_three,
  param_for_step_one: true,
  param_for_step_three: true
)
octo_option_three_failure = SomeAction.call(
  octo_key: :option_three,
  param_for_step_one: false,
  param_for_step_three: true
)
puts octo_option_one_success # =>
# Result: success

# Railway Flow:
#   init_step -> my_octo -> step_one -> step_two -> final_step

# Context:
#   {:octo_key=>:option_one, :param_for_step_one=>true, :param_for_step_two=>true, :custom_key=>:option_one, :step_one=>true, :step_two=>true, :final_step=>"Success"}

# Errors:
#   {}
puts octo_option_one_failure # =>
# Result: success

# Railway Flow:
#   init_step -> my_octo -> step_one -> final_step

# Context:
#   {:octo_key=>:option_one, :param_for_step_one=>false, :param_for_step_two=>true, :custom_key=>:option_one, :step_one=>false, :final_step=>"Success"}

# Errors:
#   {}
puts octo_option_two_success # =>
# Result: success

# Railway Flow:
#   init_step -> my_octo -> step_two -> step_three -> final_step

# Context:
#   {:octo_key=>:option_two, :param_for_step_two=>true, :param_for_step_three=>true, :custom_key=>:option_two, :step_two=>true, :step_three=>true, :final_step=>"Success"}

# Errors:
#   {}
puts octo_option_two_failure # =>
# Result: failure

# Railway Flow:
#   init_step -> my_octo -> step_two -> step_three -> fail_two

# Context:
#   {:octo_key=>:option_two, :param_for_step_two=>true, :param_for_step_three=>false, :custom_key=>:option_two, :step_two=>true, :step_three=>false, :fail_two=>"Failure"}

# Errors:
#   {}
puts octo_option_three_success # =>
# Result: success

# Railway Flow:
#   init_step -> my_octo -> step_three -> step_one -> final_step

# Context:
#   {:octo_key=>:option_three, :param_for_step_one=>true, :param_for_step_three=>true, :custom_key=>:option_three, :step_three=>true, :step_one=>true, :final_step=>"Success"}

# Errors:
#   {}
puts octo_option_three_failure # =>
# Result: failure

# Railway Flow:
#   init_step -> my_octo -> step_three -> step_one -> fail_one -> fail_two

# Context:
#   {:octo_key=>:option_three, :param_for_step_one=>false, :param_for_step_three=>true, :custom_key=>:option_three, :step_three=>true, :step_one=>false, :fail_one=>"Failure", :fail_two=>"Failure"}

# Errors:
#   {}
