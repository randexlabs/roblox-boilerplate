---
name: jecs-gizmo
description: Practical reference for jecs-gizmo, a Luau helper for drawing debug gizmos from jecs component data. Use when Codex needs to answer questions about world setup, component mapping, gizmo marker components, style overrides, runtime update order, or implementation caveats such as ignored distance styles and global module state.
---

# jecs-gizmo

Use this skill for practical questions about `jecs-gizmo`, especially when a user is visualizing ECS transforms, positions, directions, look vectors, or entity-to-entity distances in Studio.

## Quick Routing

- For what the library does, what it exposes, and when to use each gizmo type, read [references/overview.md](references/overview.md).
- For setup order, required component mapping, and a working integration pattern, read [references/getting-started.md](references/getting-started.md).
- For the runtime model, query construction, style flow, and how each marker component is interpreted, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For mismatches between docs and implementation, failure modes, and debugging advice, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Module state, exported fields, initialization, and style shape: [references/apis/module-state-and-setup.md](references/apis/module-state-and-setup.md)
- Gizmo marker components and per-frame drawing behavior: [references/apis/runtime-gizmo-components.md](references/apis/runtime-gizmo-components.md)

## Working Rules

- Treat `world(world)` as mandatory initialization before using `system()` or any generated `gizmo.*` component ids.
- Be explicit that the caller must assign the data-bearing component ids (`cframe`, `position`, `direction`) before `world(world)` if they want those data sources to be queryable.
- Schedule `system()` after the rest of the gameplay systems have written the latest ECS values for the frame.
- Mention that the module keeps mutable global state for one active world at a time rather than returning isolated instances.
- Call out documented mismatches when relevant: the README's `scale = true` example is wrong for the actual `number`-typed field, and distance gizmo styles are currently ignored by the implementation.
