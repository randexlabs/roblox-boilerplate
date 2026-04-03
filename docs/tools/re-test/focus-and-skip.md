# Focus And Skip

## Focus

When `focus` has tests, only focused tests run.

```luau
local run, focus = {}, {}

function focus.should_debug_this_specific_issue()
    print('debugging here')
end

function run.should_skip_this_test()
    error('shouldnt run')
end
```

## Skip

Use `skip` to disable tests temporarily.

```luau
local run, skip = {}, {}

function run.should_run_this_test()
    assert(true)
end

function skip.should_skip_this_test()
    error('shouldnt run')
end
```
