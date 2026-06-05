---
name: jecs-spring
description: Practical reference for jecs-spring, a Luau helper that drives Ripple springs from jecs pair components. Use when Codex needs to answer questions about world setup, goal and options pairs, motion access, per-frame stepping order, completion detection, or runtime caveats such as global module state and internal completion handler entities.
---

# jecs-spring

Use this skill for practical questions about `jecs-spring`, especially when a user is animating ECS component values toward goals with Ripple springs inside a shared jecs world.

## Quick Routing

- For what the library does, what it exports, and the main data model, read [references/overview.md](references/overview.md).
- For setup order, required integration steps, and a working usage pattern, read [references/getting-started.md](references/getting-started.md).
- For the runtime mental model, lifecycle of goal/options/motion/completed pairs, and how updates propagate, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For mismatches between docs and implementation, failure modes, and debugging advice, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Module exports, mutable state, and initialization: [references/apis/module-state-and-setup.md](references/apis/module-state-and-setup.md)
- Goal, options, motion, completion, and step-time behavior: [references/apis/runtime-spring-components.md](references/apis/runtime-spring-components.md)

## Working Rules

- Treat `world(world)` as mandatory initialization before using any generated component ids or calling `system(delta)`.
- Schedule `system(delta)` before the part of the frame that consumes the animated component values, because `system(delta)` writes the stepped values back into the world.
- Explain pair usage precisely: `goal`, `options`, `motion`, and `completed` are used as pair first-elements, and the animated component id is the pair second-element.
- Mention that the module stores global mutable state for one active world at a time rather than returning isolated instances.
- Call out the main runtime caveat when relevant: querying `pair(completed, component)` can also match internal controller entities, not only the user-facing animated entities.
