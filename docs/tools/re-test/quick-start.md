# Quick Start

Create a `.spec.luau` file:

```luau
local run = {}

function run.should_run()
    assert(1 + 1 == 2, "Basic math should work")
end

return run
```

Run:

```bash
pesde x ernisto/test -- tests
```
