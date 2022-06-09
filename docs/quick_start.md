## Quick start

### Installation

Regular installation
```
gem install decouplio
```

Gemfile
```ruby
gem 'decouplio'
```

### Usage

All you need to do is to create new class and inherit it from `Decouplio::Action`, define your action logic and implement methods.

```ruby
require 'decouplio'

class ProcessNumber < Decouplio::Action
  logic do
    step :multiply
    step :divide
  end

  def multiply(number:, multiplier:, **)
    ctx[:result] = number * multiplier
  end

  def divide(result:, divider:, **)
    ctx[:result] = result / divider
  end
end

action = ProcessNumber.call(number: 5, multiplier: 4, divider: 10) # =>
# Result: success

# Railway Flow:
#   multiply -> divide

# Context:
#   {:number=>5, :multiplier=>4, :divider=>10, :result=>2}

# Errors:
#   {}

action[:number] # => 5
action[:multiplier] # => 4
action[:divider] # => 10
action[:result] # => 2

action.success? # => true
action.failure? # => false

action.railway_flow # => [:multiply, :divide]

# OR

class RaisingAction < Decouplio::Action
  logic do
    step :step_one
    step :step_two
  end

  def step_one(step_one_param:, **)
    ctx[:step_one] = step_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end
end

begin
  RaisingAction.call!(step_one_param: false)
rescue Decouplio::Errors::ExecutionError => exception
  exception.message # => Action failed.
  exception.action # =>
  # Result: failure

  # Railway Flow:
  #   step_one

  # Context:
  #   :step_one_param => false
  #   :step_one => false

  # Errors:
  #   None
end
```
Learn more about all features:
- [Logic block](https://github.com/differencialx/decouplio/blob/master/docs/logic_block.md)
  - [Context](https://github.com/differencialx/decouplio/blob/master/docs/context.md)
  - [Step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
  - [Fail](https://github.com/differencialx/decouplio/blob/master/docs/fail.md)
  - [Pass](https://github.com/differencialx/decouplio/blob/master/docs/pass.md)
  - [Octo](https://github.com/differencialx/decouplio/blob/master/docs/octo.md)
  - [Wrap](https://github.com/differencialx/decouplio/blob/master/docs/wrap.md)
  - [Resq](https://github.com/differencialx/decouplio/blob/master/docs/resq.md)
  - [Inner action](https://github.com/differencialx/decouplio/blob/master/docs/inner_action.md)
  - [Doby/Aide](https://github.com/differencialx/decouplio/blob/master/docs/doby_aide.md)
  - [Step as a service](https://github.com/differencialx/decouplio/blob/master/docs/step_as_a_service.md)
- [Error store](https://github.com/differencialx/decouplio/blob/master/docs/error_store.md)
