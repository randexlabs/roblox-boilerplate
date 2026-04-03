# Test File Format

## Basic

```luau
local run = {}

function run.should_run()
    assert(true)
end

return run
```

## Advanced

```luau
local run, focus, skip = {}, {}, {}

function run.should_run()
    assert(true)
end

function focus.should_focus_this_test()
    print('debugging here')
end

function skip.should_skip_this_test()
    error('shouldnt run')
end

return { run = run, focus = focus, skip = skip, name = 'my_suite' }
```
