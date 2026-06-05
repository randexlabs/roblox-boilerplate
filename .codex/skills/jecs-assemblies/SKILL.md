---
name: jecs-assemblies
description: Practical reference for jecs-assemblies, a Luau helper for maintaining chained relative CFrame transforms across jecs entity relationships. Use when Codex needs to answer questions about pivot chains, transform propagation order, world setup, `swap_pivot`, exposed component ids, or runtime caveats in the module's assembly bookkeeping.
---

# jecs-assemblies

Use this skill for practical questions about `jecs-assemblies`, especially when a user is building hierarchical transforms on top of `jecs` entities and needs the exact runtime behavior of pivot chains, setup order, or reparenting.

## Quick Routing

- For what the library does, what problem it solves, and which exports are part of the normal surface, read [references/overview.md](references/overview.md).
- For setup order, minimum integration steps, and a working usage pattern, read [references/getting-started.md](references/getting-started.md).
- For the assembly model, traversal behavior, transform propagation semantics, and pivot swapping mental model, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For sharp edges, inferred caveats from implementation, and debugging advice, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Module state, component ids, default export shape, and setup entrypoints: [references/apis/module-state-and-setup.md](references/apis/module-state-and-setup.md)
- Transform propagation and pivot mutation operations: [references/apis/runtime-operations.md](references/apis/runtime-operations.md)

## Working Rules

- Treat `world(world)` as mandatory initialization before any other meaningful use.
- Treat `system()` as an explicit runtime step that should run immediately before the rest of your code consumes propagated transform CFrames.
- Be explicit that `pivot` is used as a jecs pair relation, while `relative` and `transform` are data-bearing components.
- Mention that `swap_pivot()` preserves world-space transform only when both the entity and the new pivot already have `transform` values.
- Call out that the module stores global mutable state. Reconfiguring it for multiple worlds in the same runtime is not modeled as an isolated instance API.
