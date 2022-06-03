require_relative '../lib/decouplio'

class SemanticDeny
  def self.call(ctx:, error_store:, semantic:, error_message:)
    ctx[:semantic] = semantic
    error_store.add_error(semantic, error_message)
  end
end

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    deny SemanticDeny, semantic: :bad_request, error_message: 'Bad request'
    step :step_two
  end

  def step_one(step_one_param:, **)
    ctx[:step_one] = step_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_one(**)
    ctx[:fail_one] = 'Failure'
  end
end

success_action = SomeAction.call(step_one_param: true)
failure_action = SomeAction.call(step_one_param: false)

success_action # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   :step_one_param => true
#   :step_one => true
#   :step_two => "Success"

# Errors:
#   None

failure_action # =>
# Result: failure

# Railway Flow:
#   step_one -> SemanticDeny

# Context:
#   :step_one_param => false
#   :step_one => false
#   :semantic => :bad_request

# Errors:
#   :bad_request => ["Bad request"]
