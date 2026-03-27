# Additional considerations (modules)

## When to read this

- You want to understand how the type checker reasons about `require(...)`.
- You’re hitting issues with cyclic module dependencies.

## Module interactions

If require paths are statically resolvable, Luau can use them to type-check exported members and exported types.

## Cyclic dependencies

Cyclic require graphs can confuse the checker. A common escape hatch is to cast one side to `any`:

```luau
local myModule = require(MyModule) :: any
```

