# Compatibility: implementation limits

## When to read this

- You’re writing generated code or extreme metaprogramming and hit VM/compiler limits.

## Limits (documented)

- Local variables: 200 per function (includes args)
- Upvalues: 200 per function
- Registers: 255 per function
- Constants: `2^23` per function
- Instructions: `2^23` per function (control-flow related)
- Nested functions: `2^15` per function
- Stack depth: 20000 Lua calls per thread; 200 C calls per thread

These are subject to change; avoid relying on edge-of-limit behavior.

