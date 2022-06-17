# Inner Action

`step/fail/pass` steps can perform another action instead of method.

```ruby
require 'decouplio'

class InnerAction < Decouplio::Action
  logic do
    step :step_one
    step :step_two
  end

  def step_one(**)
    ctx # => ctx from parent action(SomeAction)
    ctx[:step_one] = 'Success'
  end

  def step_two(**)
    ctx # => ctx from parent action(SomeAction)
    ctx[:step_two] = 'Success'
  end
end


class SomeAction < Decouplio::Action
  logic do
    step InnerAction
    # OR
    # fail InnerAction
    # OR
    # pass InnerAction
  end
end

action = SomeAction.call

action # =>
# Result: success

# Railway Flow:
#   InnerAction -> step_one -> step_two

# Context:
#   {:step_one=>"Success", :step_two=>"Success"}

# Errors:
#   {}
```

  ```mermaid
  flowchart LR
      1(start)-->2(any_name);
      subgraph inner action;
      2(step_one)-->|success track|3(step_two);
      end
      3(step_two)-->|success track|4(finish success);
  ```

The parent action context will be passed into inner action

## Options
All options for `step/fail/pass` can be applied along with `action` option.
