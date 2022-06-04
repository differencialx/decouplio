require_relative '../lib/decouplio'

class AssignDoby
  def self.call(ctx:, to:, from: nil, value: nil, **)
    raise 'from/value is empty' unless from || value

    ctx[to] = value || ctx[from]
  end
end

class SomeAction < Decouplio::Action
  logic do
    step :user
    doby AssignDoby, to: :current_user, from: :user
  end

  def user(id:, **)
    ctx[:user] = "User with id: #{id}"
  end
end

action = SomeAction.call(id: 1)

puts action[:user] # => "User with id: 1"

puts action[:current_user] # => "User with id: 1"

puts action # =>
# Result: success

# Railway Flow:
#   user -> AssignDoby

# Context:
#   {:id=>1, :user=>"User with id: 1", :current_user=>"User with id: 1"}

# Errors:
#   {}
