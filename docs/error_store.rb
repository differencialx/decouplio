require_relative '../lib/decouplio'

# How to use
class SomeAction < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
  end

  def step_one(**)
    false
  end

  def fail_one(**)
    add_error(:something_went_wrong, 'Something went wrong')
  end
end

action = SomeAction.call

puts action # =>
# Result: failure

# Railway Flow:
#   step_one -> fail_one

# Context:
#   {}

# Errors:
#   {:something_went_wrong=>["Something went wrong"]}

puts action.errors # =>
# {:something_went_wrong=>["Something went wrong"]}




# Custom error store
class CustomErrorStore
  attr_reader :errors

  def initialize
    @errors = {}
  end

  def add_error(key:, message:, namespace: :root)
    @errors[namespace] ||= {}
    @errors[namespace].store(
      key,
      (@errors[namespace][key] || []) + [message].flatten
    )
  end

  def merge(error_store)
    @errors = deep_merge(@errors, error_store.errors)
  end

  private

  def deep_merge(this_hash, other_hash)
    this_hash.merge(other_hash) do |_key, this_val, other_val|
      if this_val.is_a?(Hash) && other_val.is_a?(Hash)
        deep_merge(this_val, other_val)
      else
        this_val + other_val
      end
    end
  end
end

class SomeActionWithCustomErrorStore < Decouplio::Action
  error_store_class CustomErrorStore

  logic do
    step :step_one
    step :step_two
  end

  def step_one(**)
    add_error(
      key: :under_root,
      message: 'Error Message One'
    )
  end

  def step_two(**)
    add_error(
      namespace: :step_two,
      key: :error_happened,
      message: 'Error Message Two'
    )
  end
end

action = SomeActionWithCustomErrorStore.call

puts action  # =>
# Result: success

# Railway Flow:
#   step_one -> step_two

# Context:
#   {}

# Errors:
  # {:root=>{:under_root=>["Error Message One"]}, :step_two=>{:error_happened=>["Error Message Two"]}}

puts action.errors  # =>
# {:root=>{:under_root=>["Error Message One"]}, :step_two=>{:error_happened=>["Error Message Two"]}}




# When error store is the same for parent and inner action

class InnerActionWithCustomErrorStore < Decouplio::Action
  error_store_class CustomErrorStore

  logic do
    step :inner_step
  end

  def inner_step(**)
    add_error(
      namespace: :inner,
      key: :inner_key,
      message: 'Somebody was told me...'
    )
  end
end

class ParentActionWithCustomErrorStore < Decouplio::Action
  error_store_class CustomErrorStore

  logic do
    step :step_one, action: InnerActionWithCustomErrorStore
    step :step_two
  end

  def step_two(**)
    add_error(
      namespace: :parent,
      key: :error_happened,
      message: 'Message'
    )
  end
end

action = ParentActionWithCustomErrorStore.call

puts action  # =>
# Result: success

# Railway Flow:
#   step_one -> inner_step -> step_two

# Context:
#   {}

# Errors:
#   {:inner=>{:inner_key=>["Somebody was told me..."]}, :parent=>{:error_happened=>["Message"]}}

puts action.errors  # =>
# {:inner=>{:inner_key=>["Somebody was told me..."]}, :parent=>{:error_happened=>["Message"]}}




# When error store is different for parent and inner action

class InnerActionWithDefaultErrorStore < Decouplio::Action
  logic do
    step :inner_step
  end

  def inner_step(**)
    add_error(
      key: :inner_key,
      message: 'Somebody was told me...'
    )
  end
end

class ParentActionForInnerActionDefaultErrorStore < Decouplio::Action
  error_store_class CustomErrorStore

  logic do
    step :step_one, action: InnerActionWithDefaultErrorStore
    step :step_two
  end

  def step_two(**)
    add_error(
      namespace: :parent,
      key: :error_happened,
      message: 'Message'
    )
  end
end # =>
# Error store for action and inner action should be the same. (Decouplio::Errors::ErrorStoreError)
