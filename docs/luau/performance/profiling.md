# Profiling Luau code (`--profile`)

## When to read this

- You want to understand the built-in sampling profiler output.

## Running

Use an optimized interpreter build when profiling:

```text
luau --profile path/to/script.luau
```

This writes a profiler dump (often `profile.out`) that can be converted into an interactive flamegraph (commonly via a `perfgraph.py` utility in the upstream Luau repo).

## Interpreting flamegraphs

- Bar width roughly correlates with time spent.
- Nesting follows the call stack.
- Anonymous closures may show source locations without names; prefer named `local function f()` for clearer labels.

