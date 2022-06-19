# Doby/Aide

Steps which make configurable manipulations with action context.


## Signature

```ruby
doby(class_constant, **options)
aide(class_constant, **options)
```

## Behavior

### Doby

- `doby` behaves similar to `step`, depending on `.call` method returning value(truthy or falsy) the execution will be moved to `success or failure` track accordingly.
- `doby` doesn't have `on_success, on_failure, if, unless, finish_him` options.
- All options passed after class constant will be passed as kwargs for `.call` method.

### Aide
- `aide` behaves similar to `fail`, no matter which value will be returned by `.call` method, it moves to `failure` track.
- `aide` doesn't have `on_success, on_failure, if, unless, finish_him` options.
- All options passed after class constant will be passed as kwargs for `.call` method.


## How to use?

Create the ruby class which has `.call` class method.

`.call` method signature:
```ruby
# :ctx - it's a ctx from Decouplio::Action
# :error_store - it's an error_store from Decouplio::Action
#                you can call #add_error method on it.
# ** - kwargs passed from action.
def self.call(ctx:, error_store:, **)
end
```

```ruby
class AssignDoby
  def self.call(ctx:, to:, from: nil, value: nil, **)
    raise 'from/value is empty' unless from || value

    ctx[to] = value || ctx[from]
  end
end

# OR

class SemanticAide
  def self.call(ctx:, error_store:, semantic:, error_message:)
    ctx[:semantic] = semantic
    error_store.add_error(semantic, error_message)
  end
end

# OR

# If you don't need ctx and error_store, you can omit them
class DummyDoby
  def self.call(dummy:, **)
    puts dummy
  end
end
```

`AssignDoby` example.
```ruby
require 'decouplio'

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
`SemanticAide` example.
```ruby
require 'decouplio'

class SemanticAide
  def self.call(ctx:, error_store:, semantic:, error_message:)
    ctx[:semantic] = semantic
    error_store.add_error(semantic, error_message)
  end
end

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    aide SemanticAide, semantic: :bad_request, error_message: 'Bad request'
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
#   step_one -> SemanticAide

# Context:
#   :step_one_param => false
#   :step_one => false
#   :semantic => :bad_request

# Errors:
#   :bad_request => ["Bad request"]
```


## Options

### Doby
Has the same options and behavior as [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md), just specify them along with doby class options like here:
```ruby
# ...

logic do
  doby AssignDoby,
       to: :current_user,
       from: :user,
       on_success: :finish_him,
       if: :condition
end

# ...
```

### Aide
Has the same options and behavior as [fail](https://github.com/differencialx/decouplio/blob/master/docs/fail.md), just specify them along with aide class options like here:

```ruby
# ...

logic do
  step :step_one
  aide SemanticAide,
       semantic: :bad_request,
       error_message: 'Bad request',
       on_failure: :PASS,
       unless: :condition
end

# ...
```
