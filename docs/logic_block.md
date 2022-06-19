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
|step|[--->>>](https://github.com/differencialx/decouplio/step.md)|
|fail|[--->>>](https://github.com/differencialx/decouplio/fail.md)|
|pass|[--->>>](https://github.com/differencialx/decouplio/pass.md)|
|octo|[--->>>](https://github.com/differencialx/decouplio/octo.md)|
|wrap|[--->>>](https://github.com/differencialx/decouplio/wrap.md)|
|resq|[--->>>](https://github.com/differencialx/decouplio/resq.md)|
|doby|[--->>>](https://github.com/differencialx/decouplio/doby_aide.md)|
|aide|[--->>>](https://github.com/differencialx/decouplio/doby_aide.md)|
|inner action|[--->>>](https://github.com/differencialx/decouplio/inner_action.md)|
|step as service|[--->>>](https://github.com/differencialx/decouplio/step_as_a_service.md)|
