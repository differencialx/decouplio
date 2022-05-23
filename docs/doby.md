# Doby

It's a step type to make configurable manipulations with action context.


## Signature

```ruby
doby(class_constant, **options)
```

## How to use?

Create the ruby class which has `.call` class method.

`.call` method signature:
```ruby
# :ctx - is the required kwarg
# ** - kwargs passed from action
def self.call(ctx:, **)
end
```

```ruby
class AssignDoby
  def self.call(ctx:, to:, from: nil, value: nil)
    raise 'from/value is empty' unless from || value

    ctx[to] = value || ctx[from]
  end
end
```

Now you can use `AssignDoby` class inside action
```ruby
require 'decouplio'

class AssignDoby
  def self.call(ctx:, to:, from: nil, value: nil)
    raise 'from/value is empty' unless from || value

    ctx[to] = value || ctx[from]
  end
end

class SomeAction < Decouplio::Action
  logic do
    step :user
    step AssignDoby, to: :current_user, from: :user
  end

  def user(id:, **)
    ctx[:user] = "User with id: #{id}"
  end
end

action = SomeAction.call(id: 1)

action[:user] # => "User with id: 1"

action[:current_user] # => "User with id: 1"

action # =>
# Result: success

# Railway Flow:
#   user -> AssignDoby

# Context:
#   {:id=>1, :user=>"User with id: 1", :current_user=>"User with id: 1"}

# Errors:
#   {}
```

## Behavior

- `doby` behaves similar to `step`, depending on `.call` method returning value(truthy or falsy) the execution will be moved to `success or failure` track accordingly.
- `doby` doesn't have `on_success, on_failure, if, unless, finish_him` options.
- All options passed after class constant will be passed as kwargs for `.call` method.
