# Fail

`fail` is the special type of step to mark failure track

## Signature

```ruby
fail(step_name, **options)
```

## Behavior

 - when step method(`#fail_one`) returns truthy or falsy value then it goes to failure track(`step_two` step) if `on_success:` or `on_failure:` option wasn't passed(see `on_success, on_failure` docs)

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeAction < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end

    success_action = SomeAction.call(param_for_step_one: true)
    failure_action = SomeAction.call(param_for_step_one: false)

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
    #   step_one -> fail_one -> fail_two

    # Context:
    #   {:param_for_step_one=>false, :action_failed=>true, :fail_two=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
    flowchart LR
        1(start)-->2(step_one);
        2(step_one)-->|success track|3(finish_success);
        2(step_one)-->|failure track|4(fail_one);
        4(fail_one)-->|failure track|5(fail_two);
        5(fail_two)-->|failure track|F(finish_failure);
  ```

</p>
</details>

***

## Options

### on_success:
|Allowed values|Description|
|-|-|
|:finish_him|action stops execution if `fail` method returns truthy value|
|symbol with next step name|step with specified symbol name performs if step method returns truthy value|
|:PASS|will direct execution flow to nearest success track step. If current step is the last step when action will finish as `success`|
|:FAIL|will direct execution flow to nearest failure track step. If current step is the last step when action will finish as `failure`|

### on_success: :finish_him

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnSuccessFinishHim < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one, on_success: :finish_him
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(fail_one_param:, **)
        ctx[:action_failed] = fail_one_param
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end

    success_action = SomeActionOnSuccessFinishHim.call(
      param_for_step_one: true
    )
    fail_step_success = SomeActionOnSuccessFinishHim.call(
      param_for_step_one: false,
      fail_one_param: true
    )
    fail_step_failure = SomeActionOnSuccessFinishHim.call(
      param_for_step_one: false,
      fail_one_param: false
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one

    # Context:
    #   {:param_for_step_one=>true}

    # Errors:
    #   {}

    fail_step_success # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true}

    # Errors:
    #   {}

    fail_step_failure  # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :fail_two=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(finish_success);
      2(step_one)-->|failure track|4(fail_one success);
      2(step_one)-->|failure track|7(fail_one failure);
      4(fail_one success)-->|failure track|5(finish_failure);
      7(fail_one failure)-->|failure track|6(fail_two);
      6(fail_two)-->|failure track|5(finish_failure);
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
        step :step_one
        fail :fail_one, on_success: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(fail_one_param:, **)
        ctx[:action_failed] = fail_one_param
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end

    success_action = SomeActionOnSuccessToSuccessTrack.call(
      param_for_step_one: true
    )
    fail_step_success = SomeActionOnSuccessToSuccessTrack.call(
      param_for_step_one: false,
      fail_one_param: true
    )
    fail_step_failure = SomeActionOnSuccessToSuccessTrack.call(
      param_for_step_one: false,
      fail_one_param: false
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}

    fail_step_success # =>
    # Result: success

    # Railway Flow:
    #   step_one -> fail_one -> step_two

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :step_two=>"Success"}

    # Errors:
    #   {}

    fail_step_failure  # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :fail_two=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(finish_success);
      2(step_one)-->|failure track|5(fail_one success);
      2(step_one)-->|failure track|6(fail_one failure);
      5(fail_one success)-->|success track|3(step_two);
      6(fail_one failure)-->|failure track|7(fail_two);
      7(fail_two)-->|failure track|8(finish_failure);
  ```

</p>
</details>

***

### on_success: next failure track step

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnSuccessToFailureTrack < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one, on_success: :fail_three
        step :step_two
        fail :fail_two
        fail :fail_three
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(fail_one_param:, **)
        ctx[:action_failed] = fail_one_param
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end

      def fail_three(**)
        ctx[:fail_three] = 'Failure'
      end
    end

    success_action = SomeActionOnSuccessToFailureTrack.call(
      param_for_step_one: true
    )
    fail_step_success = SomeActionOnSuccessToFailureTrack.call(
      param_for_step_one: false,
      fail_one_param: true
    )
    fail_step_failure = SomeActionOnSuccessToFailureTrack.call(
      param_for_step_one: false,
      fail_one_param: false
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}


    fail_step_success # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_three

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :fail_three=>"Failure"}

    # Errors:
    #   {}


    fail_step_failure  # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two -> fail_three

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :fail_two=>"Failure", :fail_three=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(finish success);
      2(step_one)-->|failure track|5(fail_one success);
      5(fail_one success)-->|failure track|6(fail_three);
      6(fail_three)-->|failure track|7(finish failure);
      2(step_one)-->|failure track|8(fail_one failure);
      8(fail_one failure)-->|failure track|9(fail_two);
      9(fail_two)-->|failure track|6(fail_three);
  ```

</p>
</details>

***

### on_success: :PASS
<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'
    class SomeActionOnSuccessPass < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one, on_success: :PASS
      end

      def step_one(**)
        ctx[:step_one] = false
      end

      def fail_one(fail_one_param:, **)
        ctx[:fail_one] = fail_one_param
      end
    end

    fail_step_success = SomeActionOnSuccessPass.call(fail_one_param: true)
    fail_step_failure = SomeActionOnSuccessPass.call(fail_one_param: false)

    fail_step_success # =>
    # Result: success

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   :fail_one_param => true
    #   :step_one => false
    #   :fail_one => true

    # Errors:
    #   {}

    fail_step_failure # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   :fail_one_param => false
    #   :step_one => false
    #   :fail_one => false

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|failure track|3(fail_one);
      3(fail_one)-->|on_success: :PASS|5(finish_success);
      3(fail_one)-->|failure track|4(finish_failure);
  ```
</p>
</details>

***

### on_success: :FAIL
It will perform like regular `fail` step, just move to next failure track step.

***

### on_failure:
|Allowed values|Description|
|-|-|
|:finish_him|action stops execution if `fail` method returns falsy value|
|symbol with next step name|step with specified symbol name performs if step method returns falsy value|
|:PASS|will direct execution flow to nearest success track step. If current step is the last step when action will finish as `success`|
|:FAIL|will direct execution flow to nearest failure track step. If current step is the last step when action will finish as `failure`|

### on_failure: :finish_him

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnFailureFinishHim < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one, on_failure: :finish_him
        step :step_two
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(fail_one_param:, **)
        ctx[:action_failed] = fail_one_param
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end

    success_action = SomeActionOnFailureFinishHim.call(
      param_for_step_one: true
    )
    fail_step_success = SomeActionOnFailureFinishHim.call(
      param_for_step_one: false,
      fail_one_param: true
    )
    fail_step_failure = SomeActionOnFailureFinishHim.call(
      param_for_step_one: false,
      fail_one_param: false
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}


    fail_step_success # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :fail_two=>"Failure"}

    # Errors:
    #   {}


    fail_step_failure  # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(finish_success);
      2(step_one)-->|failure track|5(fail_one success);
      5(fail_one success)-->|failure track|6(fail_two);
      6(fail_two)-->|failure track|7(finish failure);
      2(step_one)-->|failure track|8(fail_one failure);
      8(fail_one failure)-->|failure track|7(finish failure);
  ```
</p>
</details>

***

### on_failure: next success track step

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionOnFailureToSuccessTrack < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(fail_one_param:, **)
        ctx[:action_failed] = fail_one_param
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end

    success_action = SomeActionOnFailureToSuccessTrack.call(
      param_for_step_one: true
    )
    fail_step_success = SomeActionOnFailureToSuccessTrack.call(
      param_for_step_one: false,
      fail_one_param: true
    )
    fail_step_failure = SomeActionOnFailureToSuccessTrack.call(
      param_for_step_one: false,
      fail_one_param: false
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}

    fail_step_success # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :fail_two=>"Failure"}

    # Errors:
    #   {}


    fail_step_failure  # =>
    # Result: success

    # Railway Flow:
    #   step_one -> fail_one -> step_two

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :step_two=>"Success"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(finish success);
      2(step_one)-->|failure track|4(fail_one success);
      4(fail_one success)-->|failure track|5(fail_two);
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
        step :step_one
        fail :fail_one, on_failure: :fail_three
        step :step_two
        fail :fail_two
        fail :fail_three
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(fail_one_param:, **)
        ctx[:action_failed] = fail_one_param
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end

      def fail_three(**)
        ctx[:fail_three] = 'Failure'
      end
    end

    success_action = SomeActionOnFailureToFailureTrack.call(
      param_for_step_one: true
    )
    fail_step_success = SomeActionOnFailureToFailureTrack.call(
      param_for_step_one: false,
      fail_one_param: true
    )
    fail_step_failure = SomeActionOnFailureToFailureTrack.call(
      param_for_step_one: false,
      fail_one_param: false
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}
    fail_step_success # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two -> fail_three

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true, :fail_two=>"Failure", :fail_three=>"Failure"}

    # Errors:
    #   {}
    fail_step_failure  # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_three

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false, :fail_three=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(finish_success);
      2(step_one)-->|failure track|5(fail_one success);
      5(fail_one success)-->|failure track|6(fail_two);
      6(fail_two)-->|failure track|7(fail_three);
      7(fail_three)-->|failure track|8(finish failure);
      2(step_one)-->|failure track|9(fail_one failure);
      9(fail_one failure)-->|failure track|7(fail_three);
  ```
</p>
</details>

***

### on_failure: :PASS

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'
  class SomeActionOnFailurePass < Decouplio::Action
    logic do
      step :step_one
      fail :fail_one, on_failure: :PASS
    end

    def step_one(**)
      false
    end

    def fail_one(fail_one_param:, **)
      ctx[:fail_one] = fail_one_param
    end
  end

  fail_step_success = SomeActionOnFailurePass.call(fail_one_param: true)
  fail_step_failure = SomeActionOnFailurePass.call(fail_one_param: false)

  fail_step_success # =>
  # Result: failure

  # Railway Flow:
  #   step_one -> fail_one

  # Context:
  #   :fail_one_param => true
  #   :fail_one => true

  # Errors:
  #   {}

  fail_step_failure # =>
  # Result: success

  # Railway Flow:
  #   step_one -> fail_one

  # Context:
  #   :fail_one_param => false
  #   :fail_one => false

  # Errors:
  #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|failure track|3(fail_one);
      3(fail_one)-->|failure track|4(finish_failure);
      3(fail_one)-->|on_failure: :PASS|5(finish_success);
  ```
</p>
</details>

***

### on_failure: :FAIL
It will perform like regular `fail` step, just move to next failure track step.

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
        fail :fail_two, if: :some_condition?
        fail :fail_three
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

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end

      def fail_three(**)
        ctx[:fail_three] = 'Failure'
      end

      def some_condition?(if_condition_param:, **)
        if_condition_param
      end
    end

    success_action = SomeActionOnIfCondition.call(
      param_for_step_one: true
    )
    fail_condition_positive = SomeActionOnIfCondition.call(
      param_for_step_one: false,
      if_condition_param: true
    )
    fail_condition_negative = SomeActionOnIfCondition.call(
      param_for_step_one: false,
      if_condition_param: false
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}

    fail_condition_positive # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two -> fail_three

    # Context:
    #   {:param_for_step_one=>false, :if_condition_param=>true, :action_failed=>true, :fail_two=>"Failure", :fail_three=>"Failure"}

    # Errors:
    #   {}

    fail_condition_negative  # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_three

    # Context:
    #   {:param_for_step_one=>false, :if_condition_param=>false, :action_failed=>true, :fail_three=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success tack|3(step_two);
      3(step_two)-->|success track|4(finish_success);
      2(step_one)-->|failure track|5(fail_one);
      5(fail_one)-->|condition positive|6(fail_two);
      6(fail_two)-->|failure track|7(fail_three);
      5(fail_one)-->|condition negative|7(fail_three);
      7(fail_three)-->|failure track|8(finish failure);
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
        fail :fail_two, unless: :some_condition?
        fail :fail_three
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

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end

      def fail_three(**)
        ctx[:fail_three] = 'Failure'
      end

      def some_condition?(if_condition_param:, **)
        if_condition_param
      end
    end

    success_action = SomeActionOnUnlessCondition.call(
      param_for_step_one: true
    )
    fail_condition_positive = SomeActionOnUnlessCondition.call(
      param_for_step_one: false,
      if_condition_param: false
    )
    fail_condition_negative = SomeActionOnUnlessCondition.call(
      param_for_step_one: false,
      if_condition_param: true
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}

    fail_condition_positive # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_two -> fail_three

    # Context:
    #   {:param_for_step_one=>false, :if_condition_param=>false, :action_failed=>true, :fail_two=>"Failure", :fail_three=>"Failure"}

    # Errors:
    #   {}

    fail_condition_negative  # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one -> fail_three

    # Context:
    #   {:param_for_step_one=>false, :if_condition_param=>true, :action_failed=>true, :fail_three=>"Failure"}

    # Errors:
    #   {}
  ```


  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success tack|3(step_two);
      3(step_two)-->|success track|4(finish_success);
      2(step_one)-->|failure track|5(fail_one);
      5(fail_one)-->|condition positive|6(fail_two);
      6(fail_two)-->|failure track|7(fail_three);
      5(fail_one)-->|condition negative|7(fail_three);
      7(fail_three)-->|failure track|8(finish failure);
  ```
</p>
</details>

***

### finish_him: :on_success
The same behavior as for `on_success: :finish_him`

### finish_him: :on_failure
The same behavior as for `on_failure: :finish_him`

### finish_him: true
Will finish action execution anyway

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionFinishHimTrue < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one, finish_him: true
        step :step_two
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(fail_one_param:, **)
        ctx[:action_failed] = fail_one_param
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end

    success_action = SomeActionFinishHimTrue.call(
      param_for_step_one: true
    )
    fail_step_success = SomeActionFinishHimTrue.call(
      param_for_step_one: false,
      fail_one_param: true
    )
    fail_step_failure = SomeActionFinishHimTrue.call(
      param_for_step_one: false,
      fail_one_param: false
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:param_for_step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}

    fail_step_success # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>true, :action_failed=>true}

    # Errors:
    #   {}

    fail_step_failure  # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:param_for_step_one=>false, :fail_one_param=>false, :action_failed=>false}

    # Errors:
    #   {}
  ```


  ```mermaid
  flowchart LR
      1(start)-->2(step_one);
      2(step_one)-->|success tack|3(step_two);
      3(step_two)-->|success track|4(finish_success);
      2(step_one)-->|failure track|5(fail_one success);
      5(fail_one success)-->|failure track|6(finish failure);
      2(step_one)-->|failure track|7(fail_one failure);
      7(fail_one failure)-->|failure track|6(finish failure);
  ```
</p>
</details>

***
