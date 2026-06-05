# Observers And Monitors API

## `observer(query, callback)`

Subscribe to query-relevant component changes and invoke `callback(entity, deleting?)` when the entity ends up matching the query.

Conceptually this is "notify me when something relevant happened to a current or newly matching entity."

### What It Watches

- query ids through `world:changed(...)`
- `with(...)` terms through `world:added(...)`
- `without(...)` terms through `world:removed(...)`

### Pair Behavior

For pair ids:

- changed watchers use the pair relation id
- wildcard-second pairs react to any target under that relation
- exact pairs only react when the changed id equals the full pair id

### Callback Semantics

The callback can receive a second boolean in delete-path cases triggered by `without(...)` removal handling.

In the TypeScript declarations this delete flag is not represented.

### Lifecycle

The returned object contains:

| Member         | Meaning                                               |
| -------------- | ----------------------------------------------------- |
| `disconnect()` | Remove all installed watchers and archetype observers |

## `monitor(query)`

Subscribe to transitions across the query boundary.

Return shape:

| Member              | Meaning                                               |
| ------------------- | ----------------------------------------------------- |
| `added(callback)`   | Register callback for entities that start matching    |
| `removed(callback)` | Register callback for entities that stop matching     |
| `disconnect()`      | Remove all installed watchers and archetype observers |

Behavior notes:

- callbacks are stored on the monitor object and can be set in either order
- `added` and `removed` return the same monitor object for chaining
- pair terms and `without(...)` filters are handled specially so membership is computed from source and destination archetypes, not just raw add/remove events

## How Matching Is Determined

Both APIs cache the set of archetypes currently matching the query and register archetype create/delete observers so that the cached set tracks future archetypes too.

Membership decisions are then based on whether an entity's source and destination archetypes are inside that cached set.

## Practical Guidance

Prefer:

- `observer` when you care that a relevant value changed
- `monitor` when you care that the entity entered or exited the query
- `query_changed` or `query_monitor` when you want queued draining instead of immediate callbacks
