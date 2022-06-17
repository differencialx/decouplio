# Resq

Step type which can be use to handle errors raised during step invocation.

## Signature

```ruby
resq(**options)
```

## Allowed for steps

|Step type|Allowed|
|-|-|
|step|Yes|
|fail|Yes|
|pass|Yes|
|wrap|Yes|
|octo|NO|

## Behavior

When `resq` step is defined after allowed step then it will catch error with class specified in options and call handler method. `resq` applies only for step which is defined above.

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeAction < Decouplio::Action
      logic do
        step :step_one
        resq handler_method: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one(lambda_for_step_one:, **)
        ctx[:step_one] = lambda_for_step_one.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def handler_method(error, **this_is_ctx)
        ctx[:error] = error.message
      end
    end

    success_action = SomeAction.call(lambda_for_step_one: -> { true })
    failure_action = SomeAction.call(lambda_for_step_one: -> { false })
    errored_action = SomeAction.call(
      lambda_for_step_one: -> { raise ArgumentError, 'some error message' }
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:lambda_for_step_one=>#<Proc:0x0000561525a05628 resq.rb:32 (lambda)>, :step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}
    failure_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:lambda_for_step_one=>#<Proc:0x0000561525a04f48 resq.rb:33 (lambda)>, :step_one=>false, :fail_one=>"Failure"}

    # Errors:
    #   {}
    errored_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> handler_method -> fail_one

    # Context:
    #   {:lambda_for_step_one=>#<Proc:0x0000561525a04b60 resq.rb:35 (lambda)>, :error=>"some error message", :fail_one=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
    flowchart LR
        1(start)-->2(step_one);
        2(step_one)-->|success track|3(step_two);
        3(step_two)-->|success track|4(finish success);
        2(step_one)-->|failure track|5(fail_one);
        5(fail_one)-->|failure track|6(finish failure);
        2(step_one)-->|error track|7(handler_method);
        7(handler_method)-->|error track|5(fail_one);
  ```

</p>
</details>

***

## When several error handlers and error classes

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeActionSeveralHandlersErrorClasses < Decouplio::Action
      logic do
        step :step_one
        resq handler_method_one: [ArgumentError, NoMethodError],
             handler_method_two: NotImplementedError
        step :step_two
        fail :fail_one
      end

      def step_one(lambda_for_step_one:, **)
        ctx[:step_one] = lambda_for_step_one.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def handler_method_one(error, **this_is_ctx)
        ctx[:error] = error.message
      end

      def handler_method_two(error, **this_is_ctx)
        ctx[:error] = error.message
      end
    end

    success_action = SomeActionSeveralHandlersErrorClasses.call(
      lambda_for_step_one: -> { true }
    )
    failure_action = SomeActionSeveralHandlersErrorClasses.call(
      lambda_for_step_one: -> { false }
    )
    argument_error_action = SomeActionSeveralHandlersErrorClasses.call(
      lambda_for_step_one: -> { raise ArgumentError, 'Argument error message' }
    )
    no_method_error_action = SomeActionSeveralHandlersErrorClasses.call(
      lambda_for_step_one: -> { raise NoMethodError, 'NoMethodError error message' }
    )
    no_implemented_error_action = SomeActionSeveralHandlersErrorClasses.call(
      lambda_for_step_one: -> { raise NotImplementedError, 'NotImplementedError error message' }
    )

    success_action # =>
    # Result: success

    # Railway Flow:
    #   step_one -> step_two

    # Context:
    #   {:lambda_for_step_one=>#<Proc:0x0000557a7149f638 resq.rb:106 (lambda)>, :step_one=>true, :step_two=>"Success"}

    # Errors:
    #   {}

    failure_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_one

    # Context:
    #   {:lambda_for_step_one=>#<Proc:0x0000557a7149f390 resq.rb:109 (lambda)>, :step_one=>false, :fail_one=>"Failure"}

    # Errors:
    #   {}
    argument_error_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> handler_method_one -> fail_one

    # Context:
    #   {:lambda_for_step_one=>#<Proc:0x0000557a7149f138 resq.rb:112 (lambda)>, :error=>"Argument error message", :fail_one=>"Failure"}

    # Errors:
    #   {}
    no_method_error_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> handler_method_one -> fail_one

    # Context:
    #   {:lambda_for_step_one=>#<Proc:0x0000557a7149edc8 resq.rb:115 (lambda)>, :error=>"NoMethodError error message", :fail_one=>"Failure"}

    # Errors:
    #   {}
    no_implemented_error_action # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> handler_method_two -> fail_one

    # Context:
    #   {:lambda_for_step_one=>#<Proc:0x0000557a7149e8c8 resq.rb:118 (lambda)>, :error=>"NotImplementedError error message", :fail_one=>"Failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
    flowchart LR
        1(start)-->2(step_one);
        2(step_one)-->|success track|3(step_two);
        3(step_two)-->|success track|4(finish success);
        2(step_one)-->|failure track|5(fail_one);
        5(fail_one)-->|failure track|6(finish failure);
        2(step_one)-->|ArgumentError|7(handler_method_one);
        2(step_one)-->|NoMethodError|7(handler_method_one);
        2(step_one)-->|NotImplementedError|8(handler_method_two);
        7(handler_method_one)-->|error track|5(fail_one);
        8(handler_method_two)-->|error track|5(fail_one);
  ```

</p>
</details>

***
