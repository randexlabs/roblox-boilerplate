---
name: jecs-vide
description: Practical reference for jecs-vide, a Luau helper library that exposes Vide reactive hooks for jecs entities and queries. Use when Codex needs to answer questions about required world setup, query-driven reactive state, entity component reads, relation targets, hook return types, or runtime caveats such as singleton module state, unstable query ordering, and TypeScript surface mismatches.
---

# jecs-vide

Use this skill for practical questions about `jecs-vide`, especially when a user is wiring `Vide` reactivity to data stored in a shared `jecs` world.

## Quick Routing

- For what the package is, what it exports, and the high-level integration model, read [references/overview.md](references/overview.md).
- For dependency shape, setup order, and first-use patterns, read [references/getting-started.md](references/getting-started.md).
- For the runtime mental model behind derivables, effects, monitors, and source updates, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For failure modes, stale-doc mismatches, and debugging advice, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Top-level exports, aliases, and shared module state: [references/apis/module-surface.md](references/apis/module-surface.md)
- Entity-oriented hooks for component reads, tag presence, and relation targets: [references/apis/entity-hooks.md](references/apis/entity-hooks.md)
- Query-oriented hooks and monitor-driven update behavior: [references/apis/query-hooks.md](references/apis/query-hooks.md)

## Working Rules

- Treat `world(world)` as mandatory initialization before using any hook that touches entity data.
- Explain that the package is singleton-style: every hook module stores one mutable `world` reference and does not create isolated instances.
- Mention that the hooks accept `Vide` derivables, not only raw values, so both constants and reactive getters are valid inputs.
- Call out behavioral caveats when relevant: `useQuery` mutates and re-emits the same array object, removal uses swap-remove so ordering is unstable, and `useTarget`/`useEntityHas` defer removal updates by one task tick.
- Preserve the implementation-authoritative mismatches: `useTarget` effectively returns relation target entity ids, and `useQueryFirst` uses the package's `predicator` spelling in the public TypeScript surface.
