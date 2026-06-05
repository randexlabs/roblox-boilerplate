---
name: planck
description: Practical reference for Planck, a library-agnostic Luau ECS scheduler inspired by Bevy schedules and Flecs pipelines. Use when Codex needs to answer questions about Planck schedulers, systems, initializer systems, phases, pipelines, run conditions, plugin hooks, event-driven execution, RunService integration, Jabby integration, or docs/runtime mismatches in the Planck package family.
---

# planck

Use this skill for practical questions about the `Planck` scheduler and its official plugin packages. Favor the runtime exports and public typings when the docs and package shapes disagree.

## Quick Routing

- For what Planck is, when to use it, and how the scheduler model differs from ECS storage itself, read [references/overview.md](references/overview.md).
- For installation, first scheduler setup, systems, phases, and starter project patterns, read [references/getting-started.md](references/getting-started.md).
- For design guidance around off-by-a-frame bugs, system responsibility, conditions, pipelines, and event groups, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For doc/runtime mismatches, plugin cleanup caveats, `onEvent` sharp edges, and hook pitfalls, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Core scheduler package `planck`: [references/apis/planck/overview.md](references/apis/planck/overview.md)
- RunService integration package `planck_runservice`: [references/apis/planck_runservice/overview.md](references/apis/planck_runservice/overview.md)
- Jabby integration package `planck_jabby`: [references/apis/planck_jabby/overview.md](references/apis/planck_jabby/overview.md)

## Working Rules

- Treat `Scheduler`, `Phase`, `Pipeline`, and the condition helpers as the stable core API.
- Be explicit that Planck is scheduler-only. It does not provide ECS storage; it orchestrates systems around whatever world/state arguments you pass in.
- Preserve the distinction between normal systems, initializer systems, and cleanup-aware initializers. That distinction changes runtime behavior.
- When plugin questions come up, distinguish the package shapes carefully: the Luau `planck_runservice` package exports a table with `Plugin`, `Phases`, and `Pipelines`, while `planck_jabby` exports the plugin directly.
- Mention that docs, typings, and runtime are not perfectly aligned in a few places, especially hook coverage and `onEvent`.
- Avoid encouraging access to `_private` scheduler members unless the question is specifically about internal plugin implementation or runtime mismatches.
