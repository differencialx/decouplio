# Step

`step` is the basic type of `logic` steps

## Signature

```ruby
step(step_name, **options)
```

## Behavior

 - when step method(`#step_one`) returns truthy value then it goes to success track(`step_two` step)
 - when step method(#step_one) returns falsy value then it goes to failure track(`fail_one` step)

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeAction < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one
        step :step_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end
    end

    success_action = SomeAction.call(param_for_step_one: true)
    failure_action = SomeAction.call(param_for_step_one: false)

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :result=>"Success"}

    # Errors:
    #   {}

    failure_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:param_for_step_one=>false, :action_failed=>true}

    # Errors:
    #   {}
  ```

  ```mermaid
    flowchart LR
        A(start)-->B(step_one);
        B(step_one)-->|success track|C(step_two);
        B(step_one)-->|failure track|D(fail_one);
        C(step_two)-->|success track|E(finish_success);
        D(fail_one)-->|failure track|F(finish_failure);
  ```

</p>
</details>

***

## Options

### on_success:
|Allowed values|Description|
|-|-|
|:finish_him|action stops execution if `step` method returns truthy value|
|symbol with next step name|step with specified symbol name performs if step method returns truthy value|

### on_success: :finish_him

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnSuccessFinishHim < Decouplio::Action
      logic do
        step :step_one, on_success: :finish_him
        fail :fail_one
        step :step_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end
    end

    success_action = SomeActionOnSuccessFinishHim.call(param_for_step_one: true)
    failure_action = SomeActionOnSuccessFinishHim.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one

    # Context:
    #   {:param_for_step_one=>true}

    # Errors:
    #   {}

    failure_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:param_for_step_one=>false, :action_failed=>true}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(finish_success);
      2(step_one)-->|failure track|4(fail_one);
      4(fail_one)-->|failure track|5(finish_failure);
  ```
</p>
</details>

***

### on_success: next success track step

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnSuccessToSuccessTrack < Decouplio::Action
      logic do
        step :step_one, on_success: :step_three
        fail :fail_one
        step :step_two
        step :step_three
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:result] = 'Result'
      end
    end

    success_action = SomeActionOnSuccessToSuccessTrack.call(param_for_step_one: true)
    failure_action = SomeActionOnSuccessToSuccessTrack.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_three

    # Context:
    #   {:param_for_step_one=>true, :result=>"Result"}

    # Errors:
    #   {}

    failure_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:param_for_step_one=>false, :action_failed=>true}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      A(start)-->B(step_one);
      B(step_one)-->|success track|C(step_three);
      B(step_one)-->|failure track|D(fail_one);
      C(step_three)-->|success track|E(finish_success);
      D(fail_one)-->|failure track|F(finish_failure);
  ```

</p>
</details>

***

### on_success: next failure track step

Can be used if for some reason you need to jump to fail step

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnSuccessToFailureTrack < Decouplio::Action
      logic do
        step :step_one, on_success: :fail_two
        fail :fail_one
        step :step_two
        step :step_three
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:result] = 'Result'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end

    success_action = SomeActionOnSuccessToFailureTrack.call(param_for_step_one: true)
    failure_action = SomeActionOnSuccessToFailureTrack.call(param_for_step_one: false)
    success_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_two

    # Context:
    #   {:param_for_step_one=>true, :fail_two=>"Failure"}

    # Errors:
    #   {}

    failure_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two

    # Context:
    #   {:param_for_step_one=>false, :action_failed=>true, :fail_two=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      A(start)-->B(step_one);
      B(step_one)-->|success track|C(fail_two);
      B(step_one)-->|failure track|D(fail_one);
      C(fail_two)-->|success track|E(finish_failure);
      D(fail_one)-->|failure track|C(fail_two);
      C(fail_two)-->|failure track|E(finish_failure);
  ```

</p>
</details>

***

### on_failure:
|Allowed values|Description|
|-|-|
|:finish_him|action stops execution if `step` method returns falsy value|
|symbol with next step name|step with specified symbol name performs if step method returns falsy value|

### on_failure: :finish_him

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnFailureFinishHim < Decouplio::Action
      logic do
        step :step_one, on_failure: :finish_him
        fail :fail_one
        step :step_two
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end
    end

    success_action = SomeActionOnFailureFinishHim.call(param_for_step_one: true)
    failure_action = SomeActionOnFailureFinishHim.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :result=>"Success"}

    # Errors:
    #   {}

    failure_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one

    # Context:
    #   {:param_for_step_one=>false}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|5(finish_success);
      2(step_one)-->|failure track|4(finish_failure);
  ```
</p>
</details>

***

### on_failure: next success track step

Can be used in case if you need to come back to success track

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnFailureToSuccessTrack < Decouplio::Action
      logic do
        step :step_one, on_failure: :step_three
        fail :fail_one
        step :step_two
        fail :fail_two
        step :step_three
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end
    end

    success_action = SomeActionOnFailureToSuccessTrack.call(param_for_step_one: true)
    failure_action = SomeActionOnFailureToSuccessTrack.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two -> step_three

    # Context:
    #   {:param_for_step_one=>true, :result=>"Success", :step_three=>"Success"}

    # Errors:
    #   {}


    failure_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_three

    # Context:
    #   {:param_for_step_one=>false, :step_three=>"Success"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(step_three);
      4(step_three)-->|success track|5(finish_success);
      2(step_one)-->|failure track|4(step_three);
  ```
</p>
</details>

***

### on_failure: next failure track step

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnFailureToFailureTrack < Decouplio::Action
      logic do
        step :step_one, on_failure: :fail_two
        fail :fail_one
        step :step_two
        fail :fail_two
        step :step_three
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end
    end

    success_action = SomeActionOnFailureToFailureTrack.call(param_for_step_one: true)
    failure_action = SomeActionOnFailureToFailureTrack.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two -> step_three

    # Context:
    #   {:param_for_step_one=>true, :result=>"Success", :step_three=>"Success"}

    # Errors:
    #   {}

    failure_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_two

    # Context:
    #   {:param_for_step_one=>false, :fail_two=>"failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(step_three);
      4(step_three)-->|success track|5(finish_success);
      2(step_one)-->|failure track|6(fail_two);
      6(fail_two)-->|failure track|7(finish_failure);
  ```
</p>
</details>

***

### if: condition method name
Can be used in case if for some reason step shouldn't be executed

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnIfCondition < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one
        step :step_two
        fail :fail_two
        step :step_three, if: :step_condition?
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def step_condition?(step_condition_param:, **)
        step_condition_param
      end
    end

    condition_positive = SomeActionOnIfCondition.call(
      param_for_step_one: true,
      step_condition_param: true
    )
    condition_negative = SomeActionOnIfCondition.call(
      param_for_step_one: true,
      step_condition_param: false
    )
    condition_positive # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two -> step_three

    # Context:
    #   {:param_for_step_one=>true, :step_condition_param=>true, :result=>"Success", :step_three=>"Success"}

    # Errors:
    #   {}

    condition_negative # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_condition_param=>false, :result=>"Success"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|condition positive|3(step_two);
      3(step_two)-->|condition positive|4(step_three);
      4(step_three)-->|condition positive|5(finish_success);
      2(step_one)-->|condition negative|6(step_two);
      6(step_two)-->|condition negative|7(finish_success);
  ```
</p>
</details>

***

### unless: condition method name
Can be used in case if for some reason step shouldn't be executed

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnUnlessCondition < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one
        step :step_two
        fail :fail_two
        step :step_three, unless: :step_condition?
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def step_condition?(step_condition_param:, **)
        step_condition_param
      end
    end

    condition_positive = SomeActionOnUnlessCondition.call(
      param_for_step_one: true,
      step_condition_param: true
    )
    condition_negative = SomeActionOnUnlessCondition.call(
      param_for_step_one: true,
      step_condition_param: false
    )
    condition_positive # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_condition_param=>true, :result=>"Success"}

    # Errors:
    #   {}

    condition_negative # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two -> step_three

    # Context:
    #   {:param_for_step_one=>true, :step_condition_param=>false, :result=>"Success", :step_three=>"Success"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|condition positive|3(step_two);
      3(step_two)-->|condition positive|4(finish_success);
      2(step_one)-->|condition negative|5(step_two);
      5(step_two)-->|condition negative|6(step_three);
      6(step_three)-->|condition negative|7(finish_success);
  ```
</p>
</details>

***

### finish_him: :on_success
The same behavior as for `on_success: :finish_him`

### finish_him: :on_failure
The same behavior as for `on_failure: :finish_him`
