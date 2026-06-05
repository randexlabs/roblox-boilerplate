---
name: jecs
description: Practical reference for jecs, a Luau archetype ECS with entity relationships, typed component IDs, wildcard queries, hooks, signals, cleanup traits, cached queries, and exported low-level internals. Use when Codex needs to answer questions about jecs world operations, query behavior, pairs and relationships, lifecycle hooks, cleanup policies, preregistered IDs, performance tradeoffs, or bundled helper modules.
---

# jecs

Use this skill for practical questions about the `jecs` ECS library and its bundled helper modules. Favor the public runtime behavior and typed exports from the main module when guides and examples are incomplete.

## Quick Routing

- For what `jecs` is good at, how it models entities/components/pairs, and which exports are considered everyday API versus advanced internals, read [references/overview.md](references/overview.md).
- For first-use setup, the minimum world/component workflow, preregistered IDs, and common patterns, read [references/getting-started.md](references/getting-started.md).
- For mental models around archetypes, relationships, hooks, cleanup, query caching, and fragmentation, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For sharp edges, undefined behavior, runtime-debug tips, and doc/runtime mismatches, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- World creation, entity/component lifecycle, and subscriptions: [references/apis/world-and-lifecycle.md](references/apis/world-and-lifecycle.md)
- Queries, filters, cached queries, and archetype-level iteration: [references/apis/queries.md](references/apis/queries.md)
- IDs, pairs, relationships, built-in traits, and cleanup markers: [references/apis/ids-relationships-and-traits.md](references/apis/ids-relationships-and-traits.md)
- Low-level exports and bundled helper modules: [references/apis/internals-and-helper-modules.md](references/apis/internals-and-helper-modules.md)

## Working Rules

- Treat `world:*` operations and the documented top-level constants as the primary API.
- Treat exported internals such as archetype helpers, entity-index helpers, and `ECS_*` constants as advanced tools; mention them, but call out stability and footgun risks.
- Be explicit about the distinction between tags and data-bearing components. Many mistakes in `jecs` come from using `set` where `add` is required, or `get` where `has` is required.
- Mention that preregistered IDs and `jecs.meta(...)` must be declared before `jecs.world()` if the user wants them auto-allocated into the world.
- When performance questions come up, explain fragmentation, wildcard relationships, cached queries, and archetype iteration as the real levers.
- Preserve practical warnings from the examples: hooks should be configured before first use, `OnRemove` must respect the `delete` flag, and cached queries should be finalized when no longer needed.
