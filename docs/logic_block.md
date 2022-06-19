## Logic block

It's just a block witch contains flow logic

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    # define your logic here
  end
end
```

What to put inside `logic` block?

Possible logic steps:
|Step kind|Docs|
|---------|----|
|step|[--->>>](https://github.com/differencialx/decouplio/docs/step.md)|
|fail|[--->>>](https://github.com/differencialx/decouplio/docs/fail.md)|
|pass|[--->>>](https://github.com/differencialx/decouplio/docs/pass.md)|
|octo|[--->>>](https://github.com/differencialx/decouplio/docs/octo.md)|
|wrap|[--->>>](https://github.com/differencialx/decouplio/docs/wrap.md)|
|resq|[--->>>](https://github.com/differencialx/decouplio/docs/resq.md)|
|doby|[--->>>](https://github.com/differencialx/decouplio/docs/doby_aide.md)|
|aide|[--->>>](https://github.com/differencialx/decouplio/docs/doby_aide.md)|
|inner action|[--->>>](https://github.com/differencialx/decouplio/docs/inner_action.md)|
|step as service|[--->>>](https://github.com/differencialx/decouplio/docs/step_as_a_service.md)|
