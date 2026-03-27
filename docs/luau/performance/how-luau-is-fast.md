# How Luau is fast (high level)

## When to read this

- You want a conceptual model of where Luau performance comes from.

## Key points

- Luau is optimized first for stable high performance in an interpreter (many targets can’t use JITs).
- Performance comes from VM design, bytecode design, and compiler optimizations (including some that can use type information).
- Some builds/environments provide an optional JIT component for select platforms; compilation can be opt-in (per-function/module).

## Where to go next

- `performance/profiling.md` to find bottlenecks before tuning.

