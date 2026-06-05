# Conceptual Guides

## Reactive Input Model

All hooks are built around `Vide`'s `read` helper, so the arguments can be reactive derivables.

Practical consequence:

- Passing a fixed entity id works.
- Passing a source/getter that points at the "currently selected entity" also works.
- When that derivable changes, the enclosing `effect` reruns and rebinds subscriptions.

This is the core reason the package composes well with UI state.

## Subscription Model

There are two update strategies in the package.

### Entity-Oriented Hooks

`useEntityGet`, `useEntityHas`, and `useTarget` subscribe directly to `jecs.World` event callbacks such as:

- `world:added(...)`
- `world:changed(...)`
- `world:removed(...)`

These hooks recalculate only when the relevant entity/component or entity/relation changes.

### Query-Oriented Hooks

`useQuery` and `useQueryFirst` use `jecs-utils.monitor(query)` instead of raw world events.

That means:

- they react to query membership changes rather than every component event
- they inherit the semantics of the monitor helper
- they disconnect the monitor through `vide.cleanup` when the effect reruns or is disposed

## Shared Module State

Each hook module exports a mutable `world` field and the actual hook function.

`jecs_vide.world(world)` performs two jobs:

1. Rebinds `jecs-utils` if its current world differs.
2. Writes the same world into every hook module's `world` field.

The package therefore behaves like a shared global adapter, not a factory that returns isolated hook sets.

## `useQuery` Data Model

`useQuery` initializes from `query:iter()` and then updates incrementally from monitor events.

Implementation details that matter:

- The hook keeps one `entities` array alive for the lifetime of the effect.
- The returned source always points to that same array object.
- Added entities append to the end.
- Removed entities are handled with swap-remove for O(1) deletion.

Swap-remove means the array is compact and efficient, but it also means relative order can change whenever an entity leaves the query.

## `useQueryFirst` Data Model

`useQueryFirst` does not maintain a full entity list. Instead, on each add/remove signal it recomputes:

```luau
jecs_utils.query_first(queryobj, predicator)
```

This is simpler and ensures the answer stays aligned with the current query contents, but it means the "first" entity depends on jecs query iteration order plus the optional predicate.

## Deferred Removal Handling

Two hooks intentionally defer work with `task.defer`:

- `useEntityHas` after a removal callback
- `useTarget` after a removal callback

`useQuery` also defers its removal bookkeeping.

This suggests the implementation expects the immediate removal callback timing to be unsafe or incomplete for reading final post-removal state. Future debugging should treat this as an intentional scheduling choice, not accidental inconsistency.

## Pair And Wildcard Behavior In `useEntityGet`

`useEntityGet` has the most specialized logic in the package.

When the requested `id` is a pair:

- it subscribes using the pair's first element as the component channel
- it keeps the pair second element for removal logic

If the removed id matches a wildcard-pair read, the hook scans the entity's remaining relation targets for that pair first-element and picks the first surviving match. This preserves a non-`nil` value when one matching pair is removed but another still exists.

That behavior is more nuanced than "any removal makes the source nil" and should be preserved in explanations.
