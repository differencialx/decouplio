# Decouplio

Decouplio is a zero dependency, thread safe and framework agnostic gem designed to encapsulate application business logic. It's reverse engineered through TDD and inspired by such frameworks and gems like Trailblazer, Interactor.

# How to install?

```
gem install decouplio --pre
```

### Gemfile
```
gem 'decouplio', '~> 1.0.0rc'
```

# Compatibility
  Ruby:
 - 2.7
 - 3.0

# Quick reference to docs

|Options/Step type|[**step**](https://differencialx.github.io/decouplio.github.io/step/)|[**fail**](https://differencialx.github.io/decouplio.github.io/fail/)|[**pass**](https://differencialx.github.io/decouplio.github.io/pass/)|[**wrap**](https://differencialx.github.io/decouplio.github.io/wrap/)|[**octo**](https://differencialx.github.io/decouplio.github.io/octo/)|[**resq**](https://differencialx.github.io/decouplio.github.io/resq/)|
|:-|:-:|:-:|:-:|:-:|:-:|:-:|
||[**on_success**](https://differencialx.github.io/decouplio.github.io/on_success/)|[**on_success**](https://differencialx.github.io/decouplio.github.io/on_success/)||[**on_success**](https://differencialx.github.io/decouplio.github.io/on_success/)|[**on_success**](https://differencialx.github.io/decouplio.github.io/on_success/)|-|
||[**on_failure**](https://differencialx.github.io/decouplio.github.io/on_failure/)|[**on_failure**](https://differencialx.github.io/decouplio.github.io/on_failure/)||[**on_failure**](https://differencialx.github.io/decouplio.github.io/on_failure/)|[**on_failure**](https://differencialx.github.io/decouplio.github.io/on_failure/)|-|
||[**on_error**](https://differencialx.github.io/decouplio.github.io/on_error/)|[**on_error**](https://differencialx.github.io/decouplio.github.io/on_error/)|[**on_error**](https://differencialx.github.io/decouplio.github.io/on_error/)|[**on_error**](https://differencialx.github.io/decouplio.github.io/on_error/)|[**on_error**](https://differencialx.github.io/decouplio.github.io/on_error/)|-|
||[**finish_him**](https://differencialx.github.io/decouplio.github.io/finish_him/)|[**finish_him**](https://differencialx.github.io/decouplio.github.io/finish_him/)|[**finish_him**](https://differencialx.github.io/decouplio.github.io/finish_him/)|[**finish_him**](https://differencialx.github.io/decouplio.github.io/finish_him/)||-|
||[**if/unless**](https://differencialx.github.io/decouplio.github.io/if_unless/)|[**if/unless**](https://differencialx.github.io/decouplio.github.io/if_unless/)|[**if/unless**](https://differencialx.github.io/decouplio.github.io/if_unless/)|[**if/unless**](https://differencialx.github.io/decouplio.github.io/if_unless/)|[**if/unless**](https://differencialx.github.io/decouplio.github.io/if_unless/)|-|

# Quick start
## What should you know before start?

### Action

Action is a class which encapsulates business logic. To create one just create a class and inherit it from `Decouplio::Action` class

```ruby
require 'decouplio'

class MyAction < Decouplio::Action
end
```

### Logic block

Block inside `Action` which contains definition of business logic.

```ruby
require 'decouplio'

class MyAction < Decouplio::Action
  logic do
    # logic block
  end
end
```

### Step

Step is an atomic part of business logic and it defines inside `Logic block`.

```ruby
require 'decouplio'

class MyAction < Decouplio::Action
  logic do
    step :hello_world
  end

  def hello_world
    ctx[:result] = 'Hello world'
  end
end

MyAction.call[:result] # => Hello world
```

|Step types|
|:-:|
|[**step**](https://differencialx.github.io/decouplio.github.io/step/)|
|[**fail**](https://differencialx.github.io/decouplio.github.io/fail/)|
|[**pass**](https://differencialx.github.io/decouplio.github.io/pass/)|
|[**wrap**](https://differencialx.github.io/decouplio.github.io/wrap/)|
|[**octo**](https://differencialx.github.io/decouplio.github.io/octo/)|
|[**resq**](https://differencialx.github.io/decouplio.github.io/resq/)|


### Context
Action context is an object which is used to share data between steps. It's accessible only inside step.
- To access the action context inside step you need to call `ctx` method
- `ctx` behaves like a `Hash`.
- To assign some value to `ctx` just do `ctx[:some_key] = 'some value'`
- To access `ctx` value use `ctx[:some_value]` or use a shortcut `c.some_value`

NOTE: you **can't** assign context value using `c.<some key>` shortcut.

```ruby
require 'decouplio'

class CtxIntroduction < Decouplio::Action
  logic do
    step :calculate_result
  end

  def calculate_result
    ctx[:result] = c.one + c.two
    # OR
    # c[:result] = c[:one] + c[:two]
    #OR
    # ctx[:result] = ctx[:one] + ctx[:two]
  end
end

action_result = CtxIntroduction.call(one: 1, two: 2)

action_result[:result] # => 3
```

### Success/Failure track
Execution flow of action is changing depending on step result.
- If step returns truthy value(**not** `nil|false`), when next `success` track step will be executed.
- If step returns falsy value(`nil|false`), when next `failure` track step will be executed.

|Success track|Failure track|
|-|-|
|[**step**](https://differencialx.github.io/decouplio.github.io/step/)|[**fail**](https://differencialx.github.io/decouplio.github.io/fail/)|
|[**pass**](https://differencialx.github.io/decouplio.github.io/pass/)||
|[**wrap**](https://differencialx.github.io/decouplio.github.io/wrap/)||
|[**octo**](https://differencialx.github.io/decouplio.github.io/octo/)||

```ruby
require 'decouplio'

class Divider < Decouplio::Action
  logic do
    step :validate_divider
    step :divide
    fail :failure_message
  end

  def validate_divider
    !ctx[:divider].zero?
  end

  def divide
    ctx[:result] = c.number / c.divider
  end

  def failure_message
    ctx[:error_message] = 'Division by zero is not allowed'
  end
end

divider_success = Divider.call(number: 4, divider: 2)
divider_success.success? # => true
divider_success.failure? # => false
divider_success[:result] # => 2
divider_success[:error_message] # => nil
divider_success.railway_flow # => [:validate_divider, :divide]
puts divider_success # =>
# Result: success

# RailwayFlow:
#   validate_divider -> divide

# Context:
#   :number => 4
#   :divider => 2
#   :result => 2

# Status: NONE

# Errors:
#   NONE

divider_failure = Divider.call(number: 4, divider: 0)
divider_failure.success? #=> false
divider_failure.failure? #=> true
divider_failure[:result] # => nil
divider_failure[:error_message] # => 'Division by zero is not allowed'
divider_failure.railway_flow# => [:validate_divider, :failure_message]
divider_failure # =>
# Result: failure

# RailwayFlow:
#   validate_divider -> failure_message

# Context:
#   :number => 4
#   :divider => 0
#   :error_message => "Division by zero is not allowed"

# Status: NONE

# Errors:
#   NONE

```

### Railway flow

During execution `Decouplio` is recording executed steps, so you check which steps were executed. It becomes in handy during debugging and writing test.

```ruby
class RailwayAction < Decouplio::Action
  logic do
    step :step1
    step :step2
    step :step3
  end

  def step1
    ctx[:step1] = 'Step1'
  end

  def step2
    ctx[:step2] = 'Step2'
  end

  def step3
    ctx[:step3] = 'Step3'
  end
end

railway_action = RailwayAction.call
railway_action.railway_flow.inspect # => [:step1, :step2, :step3]

railway_action # =>
# Result: success

# RailwayFlow:
#   step1 -> step2 -> step3

# Context:
#   :step1 => "Step1"
#   :step2 => "Step2"
#   :step3 => "Step3"

# Status: NONE

# Errors:
#   NONE
```

### Meta Store

Generally `metastore` is a PORO, which is accessible inside steps by calling `meta_store` method or it's alias `ms`. It was created to help developers to standardize things and keep meta info about action, because sometimes `success?` or `failure?` is not enough to make a decision about what to do next. I defined default metastore class which can manage custom action `status` and standardizes the way how error messages should be added.

That's how default `metastore` class looks like
```ruby
# frozen_string_literal: true
module Decouplio
  class DefaultMetaStore
    attr_accessor :status, :errors

    def initialize
      @errors = {}
      @status = nil
    end

    def add_error(key, messages)
      @errors.store(
        key,
        (@errors[key] || []) + [messages].flatten
      )
    end

    # This method is used to print metastore status to console
    # when you checking action output
    def to_s
      <<~METASTORE
        Status: #{@status || 'NONE'}

        Errors:
          #{errors_string}
      METASTORE
    end

    private

    def errors_string
      return 'NONE' if @errors.empty?

      @errors.map do |k, v|
        "#{k.inspect} => #{v.inspect}"
      end.join("\n  ")
    end
  end
end
```
So it's allows you do this
```ruby
  class MetaStoreAction < Decouplio::Action
    logic do
      step :always_fails
      fail :handle_fail
    end

    # Decouplio has to constants which are accessible inside steps
    # PASS = true
    # FAIL = false
    # You can use then to force step to fail or pass instead of `true` of `false`

    def always_fails
      FAIL
    end

    def handle_fail
      ms.status = :failed_and_i_duno_why
      ms.add_error(:something_went_wrong, 'Something went wrong')
      ms.add_error(:something_went_wrong, 'And I duno why :(')
    end
  end

  MetaStoreAction.call #=>
  # Result: failure
  # RailwayFlow:
  #   always_fails -> handle_fail
  # Context:
  #   Empty
  # Status: :failed_and_i_duno_why
  # Errors:
  #   :something_went_wrong => ["Something went wrong", "And I duno why :("]
```
 **NOTE: you can always define your own metastore class accordingly to your needs. [DOCS ARE HERE](https://differencialx.github.io/decouplio.github.io/meta_store/)**

### [Documentation is HERE](https://differencialx.github.io/decouplio.github.io/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/differencialx/decouplio/issues.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
