<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.0.0/mermaid.min.js"></script>

# Wrap

`wrap` is the type of step, that behaves like `step`, but can wrap several steps with block to make some pre/post actions or to [rescue an error](https://github.com/differencialx/decouplio/blob/master/docs/resq.md).

## Signature

```ruby
wrap(wrap_name, **options) do
  # steps to wrap
end
```

## Behavior

- all steps inside `wrap` step will be perceived as [inner action](https://github.com/differencialx/decouplio/blob/master/docs/inner_action.md). So depending on inner action result the `wrap` step will be move to success or failure track

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class SomeAction < Decouplio::Action
      logic do
        step :step_one

        wrap :wrap_one do
          step :step_two
          fail :fail_one
        end

        step :step_three
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        ctx[:step_one] = param_for_step_one
      end

      def step_two(param_for_step_two:, **)
        ctx[:step_two]= param_for_step_two
      end

      def fail_one(**)
        ctx[:fail_one] = 'Fail one failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Fail two failure'
      end
    end

    success_wrap_success = SomeAction.call(
      param_for_step_one: true,
      param_for_step_two: true
    )
    success_wrap_failure = SomeAction.call(
      param_for_step_one: true,
      param_for_step_two: false
    )
    failure = SomeAction.call(
      param_for_step_one: false
    )

    success_wrap_success # =>
    # Result: success

    # Railway Flow:
    #   step_one -> wrap_one -> step_two -> step_three

    # Context:
    #   {:param_for_step_one=>true, :param_for_step_two=>true, :step_one=>true, :step_two=>true, :step_three=>"Success"}

    # Errors:
    #   {}


    success_wrap_failure # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> wrap_one -> step_two -> fail_one -> fail_two

    # Context:
    #   {:param_for_step_one=>true, :param_for_step_two=>false, :step_one=>true, :step_two=>false, :fail_one=>"Fail one failure", :fail_two=>"Fail two failure"}

    # Errors:
    #   {}

    failure # =>
    # Result: failure

    # Railway Flow:
    #   step_one -> fail_two

    # Context:
    #   {:param_for_step_one=>false, :step_one=>false, :fail_two=>"Fail two failure"}

    # Errors:
    #   {}
  ```

  ```mermaid
    flowchart LR
        1(start)-->2(step_one);
        2(step_one)-->|success track|3(wrap_one);
        subgraph wrap action;
        3(wrap_one)-->|success track|4(start);
        4(start)-->5(step_two);
        5(step_two)-->|success track|6(finish success);
        5(step_two)-->|failure track|9(fail_one);
        9(fail_one)-->|failure track|10(finish failure);
        end;
        6(finish success)-->|success track|7(step_three);
        7(step_three)-->|success track|8(finish success);
        10(finish failure)-->|failure track|11(fail_two);
        11(fail_two)-->|failure track|12(finish failure);
        2(step_one)-->|failure track|11(fail_two)
  ```

</p>
</details>

***

## Options

### klass: some class, method: method to call on class

|Option|Requirements|Description|
|-|-|-|
|:klass|:method option|The class which implements `method` for wrap|
|:method|:klass option|The method which receives block as an argument|

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  ```ruby
    require 'decouplio'

    class WrapperClass
      def self.some_wrapper_method(&block)
        if block_given?
          puts 'Before wrapper action execution'
          block.call
          puts 'After wrapper action execution'
        end
      end
    end

    class SomeActionWrapKlassMethod < Decouplio::Action
      logic do
        wrap :wrap_one, klass: WrapperClass, method: :some_wrapper_method do
          step :step_one
          step :step_two
        end
      end

      def step_one(**)
        puts 'Step one'
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        puts 'Step two'
        ctx[:step_two] = 'Success'
      end
    end

    action = SomeActionWrapKlassMethod.call # =>
    # Before wrapper action execution
    # Step one
    # Step two
    # After wrapper action execution

    action # =>
    # Result: success

    # Railway Flow:
    #   wrap_one -> step_one -> step_two

    # Context:
    #   {:step_one=>"Success", :step_two=>"Success"}

    # Errors:
    #   {}
  ```

  ```mermaid
    flowchart LR
        1(start)-->2(wrap_one);
        subgraph wrap action;
        2(wrap_one)-->|success track|3(step_one);
        3(step_one)-->|success track|4(step_two);
        4(step_two)-->|success track|5(finish success);
        end;
        5(finish success)-->|success track|6(finish success)
  ```

</p>
</details>

***

### on_success:
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_success: :finish_him
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_success: next success track step
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_success: next failure track step
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_success: :PASS
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_success: :FAIL
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_failure:
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_failure: :finish_him
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_failure: next success track step
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_failure: next failure track step
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_failure: :PASS
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### on_failure: :FAIL
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### if: condition method name
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### unless: condition method name
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### finish_him: :on_success
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
### finish_him: :on_failure
The same as for [step](https://github.com/differencialx/decouplio/blob/master/docs/step.md)
