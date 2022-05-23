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
|step|[--->>>](https://differencialx.github.io/decouplio/step)|
|fail|[--->>>](https://differencialx.github.io/decouplio/fail)|
|pass|[--->>>](https://differencialx.github.io/decouplio/pass)|
|octo|[--->>>](https://differencialx.github.io/decouplio/octo)|
|wrap|[--->>>](https://differencialx.github.io/decouplio/wrap)|
|resq|[--->>>](https://differencialx.github.io/decouplio/resq)|
