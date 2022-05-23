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
|step|[--->>>](https://github.com/differencialx/decouplio/blob/master/docs/step.md)|
|fail|[--->>>](https://github.com/differencialx/decouplio/blob/master/docs/fail.md)|
|pass|[--->>>](https://github.com/differencialx/decouplio/blob/master/docs/pass.md)|
|octo|[--->>>](https://github.com/differencialx/decouplio/blob/master/docs/octo.md)|
|wrap|[--->>>](https://github.com/differencialx/decouplio/blob/master/docs/wrap.md)|
|resq|[--->>>](https://github.com/differencialx/decouplio/blob/master/docs/resq.md)|
