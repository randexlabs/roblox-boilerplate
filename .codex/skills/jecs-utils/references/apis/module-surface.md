# Module Surface API

## Default Export Shape

The Luau module returns a mutable table containing:

| Field            | Purpose                                                        |
| ---------------- | -------------------------------------------------------------- |
| `query_first`    | Return the first query match, optionally filtered by predicate |
| `query_count`    | Count matching entities quickly by archetype size              |
| `query_entities` | Gather matching entities into an array                         |
| `query_random`   | Return one random match plus component values                  |
| `query_changed`  | Create a queued iterator of changed matching entities          |
| `query_monitor`  | Create queued iterators for entered and left matches           |
| `collect`        | Convert push-style events into an iterable queue               |
| `interval`       | Build a simple throttle closure                                |
| `ref`            | Stable key-to-entity identity map                              |
| `is_a`           | Current world's inheritance relation id                        |
| `IsA`            | Alias of `is_a`                                                |
| `observer`       | Subscribe to relevant query-affecting changes                  |
| `monitor`        | Subscribe to query membership transitions                      |
| `world`          | Bind package-global world state                                |
| `__world`        | Last world bound through `world(world)`                        |
| `default`        | Alias pointing back to the same module table                   |

## Initialization API

### `world(world: World): void`

Rebind package-global state to a specific jecs world.

What it updates:

- `__world`
- internal world used by `ref`
- internal world used by `is_a`
- `is_a`
- `IsA`

Important:

- this is mutable singleton state, not instance creation
- existing query helpers do not need this call
- `ref` and `is_a` should be treated as invalid until this has run

## Top-Level Aliases

### `is_a`

After initialization, this field is the same relation id stored in the internal `is_a.is_a` field.

### `IsA`

Exact alias of `is_a`.

This exists as a naming convenience only; there is no behavioral difference.

## Hidden-But-Observable State

### `__world`

The last world passed to `world(world)`.

The TypeScript declaration treats this as always present, but the Lua module initializes it as `nil` until binding occurs.

### `default`

Points back to the same module table so default-import consumers receive the same singleton object.
