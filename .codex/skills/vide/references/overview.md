# Vide Overview

Vide is a reactive UI library for Luau inspired by Solid. Its main goals are:

- Luau-friendly typing
- declarative UI construction
- fine-grained reactivity driven by explicit reads of sources

## Public Surface At A Glance

The exported runtime surface includes:

- Core reactivity: `root`, `source`, `effect`, `derive`
- Dynamic control flow: `show`, `switch`, `indexes`, `values`
- UI creation: `create`, `mount`, `action`, `changed`
- Utility helpers: `cleanup`, `untrack`, `read`, `batch`, `context`
- Runtime/animation: `spring`, `step`, `version`
- Global flags: `strict`, `defaults`, `defer_nested_properties`
- Temporary compatibility helper: `apply`

Vide also exports public type aliases:

- `Source<T>` and `source<T>`
- `Context<T>` and `context<T>`

## How Vide Thinks

Vide code runs inside scopes.

- Stable scopes do not track reads and never rerun.
- Reactive scopes track source reads and rerun when those sources change.
- Scope ownership matters. When a scope is destroyed, the scopes created under it are destroyed too.
- Yielding inside Vide scopes is not allowed.

This means Vide is not a generic virtual-DOM renderer. It is a graph of sources and scope-owned computations.

## Typical Workflow

1. Create state with `source()`.
2. Build instances with `create()`.
3. Use plain values for static properties.
4. Use functions for reactive properties or reactive children.
5. Use `effect()` or `derive()` when you need explicit reactive computations.
6. Use `show()`, `switch()`, `indexes()`, or `values()` when UI lifetime depends on source updates.

## Runtime Versus Docs

Some published docs lag behind the exported runtime:

- `create()` still supports legacy overloads at runtime, but the changelog marks them as deprecated.
- `show()`, `switch()`, `indexes()`, and `values()` expose more callback inputs than the basic docs show.
- `indexes()` and `values()` return sources of arrays, not plain arrays.
- `strict`, `defaults`, `defer_nested_properties`, `apply`, `step`, and `version` are part of the public runtime surface even though the main API pages barely discuss them.

When precision matters, prefer the runtime behavior summarized in this skill.
