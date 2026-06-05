# IDs, Relationships, And Traits

## Pair And ID Helpers

| API                               | Purpose                                   | Notes                                            |
| --------------------------------- | ----------------------------------------- | ------------------------------------------------ |
| `jecs.pair(first, second)`        | Encode a relationship pair ID             | `first` is the relation, `second` is the target. |
| `jecs.IS_PAIR(id)`                | Check whether an ID is a pair             | Useful when handling mixed IDs dynamically.      |
| `jecs.pair_first(world, pairId)`  | Resolve the first element of a pair       | World-aware alive resolution.                    |
| `jecs.pair_second(world, pairId)` | Resolve the second element of a pair      | World-aware alive resolution.                    |
| `jecs.ECS_PAIR_FIRST(pairId)`     | Extract first raw element from a pair ID  | Low-level, not alive-aware.                      |
| `jecs.ECS_PAIR_SECOND(pairId)`    | Extract second raw element from a pair ID | Low-level, not alive-aware.                      |

Use `pair_first` / `pair_second` in normal code when the pair may refer to recycled or remapped IDs. Use the raw `ECS_PAIR_*` helpers only when you deliberately want the encoded values.

## Built-In Relationship Helpers

| Export           | Purpose                                      |
| ---------------- | -------------------------------------------- |
| `jecs.ChildOf`   | Conventional parent/child relationship       |
| `jecs.Wildcard`  | Match any relation or target in pair queries |
| `jecs.w`         | Alias of `jecs.Wildcard`                     |
| `jecs.Exclusive` | Marks a relationship or ID as exclusive      |

Typical hierarchy pattern:

```luau
world:add(child, jecs.pair(jecs.ChildOf, parent))
local parentAgain = world:parent(child)
```

## Hook Traits

These are IDs stored on component entities to define lifecycle behavior:

| Trait           | Meaning          |
| --------------- | ---------------- |
| `jecs.OnAdd`    | Add-time hook    |
| `jecs.OnChange` | Update-time hook |
| `jecs.OnRemove` | Remove-time hook |

They are configured with `world:set(ComponentId, TraitId, callback)`.

## Cleanup Traits

Conditions:

| Trait                 | Meaning                                                       |
| --------------------- | ------------------------------------------------------------- |
| `jecs.OnDelete`       | Trigger when that ID itself is deleted                        |
| `jecs.OnDeleteTarget` | Trigger when a target referenced by a relationship is deleted |

Actions:

| Trait         | Meaning                                          |
| ------------- | ------------------------------------------------ |
| `jecs.Remove` | Remove the affected ID from referencing entities |
| `jecs.Delete` | Delete the referencing entities                  |

Example:

```luau
world:add(RelationId, jecs.pair(jecs.OnDeleteTarget, jecs.Delete))
```

This means entities holding that relationship may be deleted when the target disappears.

## Metadata And Naming

| Export           | Purpose                                                        |
| ---------------- | -------------------------------------------------------------- |
| `jecs.Name`      | Built-in string metadata component for naming IDs and entities |
| `jecs.Component` | Built-in marker that makes an ID data-bearing                  |
| `jecs.Rest`      | Internal boundary marker also used in some advanced examples   |

Naming pattern:

```luau
world:set(Position, jecs.Name, "Position")
local readable = world:get(Position, jecs.Name)
```

`jecs.Name` is heavily used in helper modules and examples for diagnostics, serialization maps, and readable tooling.

## Archetype Events

These are exported built-ins, mainly relevant to cached queries and internals:

| Export                 | Purpose                                            |
| ---------------------- | -------------------------------------------------- |
| `jecs.ArchetypeCreate` | Internal/event-style marker for archetype creation |
| `jecs.ArchetypeDelete` | Internal/event-style marker for archetype deletion |

They matter because cached queries observe archetype create/delete events behind the scenes.

## Relationship Semantics To Explain Clearly

- relation = first element of the pair
- target = second element of the pair
- source = entity that owns the pair
- exact pair queries are precise and cheap
- wildcard relation/target queries are expressive but can add fragmentation and target-resolution cost
