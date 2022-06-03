# Step as a service

It's similar to [Inner action](https://github.com/differencialx/decouplio/blob/master/docs/inner_action.md), but instead of using `Decouplio::Action`, you can use PORO class.

## Signature

```ruby
(step|fail|pass)(service_class, **options)
```

## Behavior

- service class should implement `.call` class method
- service class can be used as `step` or `fail` or `pass`
- all options of `step|fail|pass` can be used as for [Inner action](https://github.com/differencialx/decouplio/blob/master/docs/inner_action.md)
- depending on returning value of `.call` method(truthy ot falsy) the execution will be moved to `success or failure` track accordingly.

## How to use?

Create a PORO class with `.call` class method.

```ruby
# :ctx - it's a ctx from Decouplio::Action
# :error_store - it's an error_store from Decouplio::Action,
#                you can call #add_error on it
class Concat
  def self.call(ctx:, **)
    new(ctx: ctx).call
  end

  def initialize(ctx:)
    @ctx = ctx
  end

  def call
    @ctx[:result] = @ctx[:one] + @ctx[:two]
  end
end

# OR

# :ctx - it's a ctx from Decouplio::Action
# :error_store - it's an error_store from Decouplio::Action,
#                you can call #add_error on it
class Subtract
  def self.call(ctx:, **)
    ctx[:result] = ctx[:one] - ctx[:two]
  end
end

# OR

class MakeRequest
  def self.call(ctx:, error_store:)
    ctx[:client].get(ctx[:url])
  rescue Net::OpenTimeout => error
    error_store.add_error(:connection_error, error.message)
  end
end
```

Now you can use these classes as a `step|fail|pass` step

```ruby
class SomeActionConcat < Decouplio::Action
  logic do
    step Concat
  end
end

action = SomeActionConcat.call(one: 1, two: 2)

puts action[:result] # => 3

puts action # =>
# Result: success

# Railway Flow:
#   Concat

# Context:
#   {:one=>1, :two=>2, :result=>3}

# Errors:
#   {}
```

OR

```ruby
class SomeActionSubtract < Decouplio::Action
  logic do
    step :init_one
    step :init_two
    step Subtract
  end

  def init_one(param_one:, **)
    ctx[:one] = param_one
  end

  def init_two(param_two:, **)
    ctx[:two] = param_two
  end
end

action = SomeActionSubtract.call(param_one: 5, param_two: 2)

puts action[:result] # => 3

puts action # =>
# Result: success

# Railway Flow:
#   init_one -> init_two -> Subtract

# Context:
#   {:param_one=>5, :param_two=>2, :one=>5, :two=>2, :result=>3}

# Errors:
#   {}

```
