# `planck` API

This folder documents the core `planck` package only.

## File Routing

- Scheduler lifecycle and runtime methods: [scheduler.md](scheduler.md)
- System shapes, initializer systems, and metadata types: [systems.md](systems.md)
- Phases, pipelines, inserts, and ordering: [phases-and-pipelines.md](phases-and-pipelines.md)
- Conditions and event collection helpers: [conditions.md](conditions.md)
- Plugin interface, hooks, and hook contexts: [plugins-and-hooks.md](plugins-and-hooks.md)

## Covered Public Surface

Runtime exports:

- `Phase`
- `Pipeline`
- `Scheduler`
- `isNot`
- `runOnce`
- `timePassed`
- `onEvent`

Type-level/public concepts from the supplied `.d.ts` and Luau exports:

- `Plugin` interface
- `System`
- `SystemFn`
- `SystemTable`
- `InitializerSystemFn`
- `InitializerResult`
- `CleanupFn`
- `SystemInfo`
- hook context types exported through the package init

## Coverage Notes

This package folder is intended to cover the public package surface, not every internal helper module in the source tree.

Not treated as core package API here:

- `DependencyGraph` internals
- low-level `utils.luau` implementation details that are not re-exported as package API
- private scheduler members prefixed with `_`, except where needed to explain runtime mismatches in official plugins
