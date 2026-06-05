# Internals And Helper Modules

This file covers exported helpers that are either low-level `jecs` internals or practical side modules included with the library.

## Low-Level `jecs` Exports

These are public exports from the main module, but they are more storage-aware and less beginner-friendly than the world API.

### Alternate Allocation Helpers

| API                        | Purpose                                                 |
| -------------------------- | ------------------------------------------------------- |
| `jecs.new(world)`          | Allocate a plain entity through the internal allocator  |
| `jecs.new_w_id(world, id)` | Allocate an entity and immediately add one ID to it     |
| `jecs.new_low_id(world)`   | Allocate an entity preferentially from the low-ID range |

These are implementation-flavored helpers. Prefer `world:entity()` and `world:component()` unless the user is deliberately mirroring internal allocation behavior.

### Record And Component Metadata

| API                                                | Purpose                                              |
| -------------------------------------------------- | ---------------------------------------------------- |
| `jecs.record(world, entity)`                       | Return the entity record                             |
| `jecs.component_record(world, id)`                 | Return the component record for one ID               |
| `jecs.id_record_ensure(world, id)`                 | Ensure a component record exists                     |
| `jecs.find_observers(world, eventId, componentId)` | Inspect archetype/query observer tables              |
| `jecs.archetype_append_to_records(...)`            | Register archetype membership into component records |

`component_record` is especially useful for advanced wildcard and archetype queries, because it exposes which archetypes currently carry a given ID and where those columns appear.

### Bulk And Archetype Helpers

| API                                                        | Purpose                                             |
| ---------------------------------------------------------- | --------------------------------------------------- |
| `jecs.bulk_insert(world, entity, ids, values)`             | Insert many IDs into one entity in one operation    |
| `jecs.bulk_remove(world, entity, ids)`                     | Remove many IDs from one entity                     |
| `jecs.archetype_create(world, ids, typeKey)`               | Create an archetype directly                        |
| `jecs.archetype_ensure(world, ids)`                        | Reuse or create an archetype for a type set         |
| `jecs.find_insert(...)`                                    | Internal helper for sorted archetype/type insertion |
| `jecs.find_archetype_with(world, id, archetype)`           | Traverse to archetype containing an added ID        |
| `jecs.find_archetype_without(world, id, archetype)`        | Traverse to archetype after removing an ID          |
| `jecs.create_edge_for_remove(...)`                         | Internal helper for cached remove-edge setup        |
| `jecs.archetype_traverse_add(world, id, archetype)`        | Low-level add traversal                             |
| `jecs.archetype_traverse_remove(world, id, archetype)`     | Low-level remove traversal                          |
| `jecs.entity_move(entityIndex, entity, record, archetype)` | Move one entity to another archetype                |

These are primarily for experiments, tooling, or custom ultra-hot paths. Most gameplay code should not call them directly.

### Entity-Index Helpers

| API                                                   | Purpose                                         |
| ----------------------------------------------------- | ----------------------------------------------- |
| `jecs.entity_index_try_get(entityIndex, entity)`      | Get a live record if the handle is valid        |
| `jecs.entity_index_try_get_fast(entityIndex, entity)` | Fast-path lookup with fewer checks              |
| `jecs.entity_index_try_get_any(entityIndex, entity)`  | Get the sparse record regardless of alive state |
| `jecs.entity_index_is_alive(entityIndex, entity)`     | Test liveness at the index level                |
| `jecs.entity_index_get_alive(entityIndex, entity)`    | Resolve a live canonical handle for an index    |
| `jecs.entity_index_new_id(entityIndex)`               | Allocate a new entity ID                        |
| `jecs.entity_index_ensure(entityIndex, entity)`       | Ensure a specific ID exists in the index        |

These helpers are used by bundled modules for debugging, visualization, and deserialization.

### Query Helpers

| API                     | Purpose                                          |
| ----------------------- | ------------------------------------------------ |
| `jecs.Query`            | Query metatype export                            |
| `jecs.query_iter`       | Build/use the low-level query iterator           |
| `jecs.query_iter_init`  | Initialize query iteration                       |
| `jecs.query_with`       | Low-level implementation of `query:with(...)`    |
| `jecs.query_without`    | Low-level implementation of `query:without(...)` |
| `jecs.query_archetypes` | Return compatible archetypes                     |
| `jecs.query_match`      | Test whether an archetype matches a query        |

### Encoded-ID Helpers And Constants

| API                                | Purpose                                     |
| ---------------------------------- | ------------------------------------------- |
| `jecs.ECS_ID(entity)`              | Extract the base entity index               |
| `jecs.ECS_GENERATION(entity)`      | Extract the generation                      |
| `jecs.ECS_GENERATION_INC(entity)`  | Increment generation encoding               |
| `jecs.ECS_COMBINE(id, generation)` | Compose a handle                            |
| `jecs.ECS_ID_IS_WILDCARD(id)`      | Check wildcard encoding                     |
| `jecs.ECS_ID_IS_EXCLUSIVE`         | Exclusive-marker bit constant/helper        |
| `jecs.ECS_ID_DELETE`               | Cleanup-delete bit constant                 |
| `jecs.ECS_ENTITY_MASK`             | Bitmask/offset constant for entity encoding |
| `jecs.ECS_META_RESET()`            | Reset preregistered metadata state          |

Treat these as internals unless the task is serialization, visualization, diagnostics, or custom tooling.

## Bundled Helper Modules

### `collect`

Purpose:

- turns a signal into a pull-based queue
- returns `(next, connection)` where `next()` yields the next captured event tuple

Best for:

- networking samples
- bridging callback-heavy APIs into polling systems

### `deserialize`

Exports:

- `ecs_ensure_entity(world, id, ctx)`
- `ecs_deser_pairs(world, rel, tgt, ctx)`

Purpose:

- remap serialized entity IDs into local world IDs
- preserve or reallocate IDs safely during replication flows

### `entity_visualiser`

Exports:

- `components(world, entity)`
- `prettify(entity)`
- `stringify(world)`

Purpose:

- print readable entity/component state
- decode generations and names
- inspect archetype rows and columns during debugging

### `lifetime_tracker`

Purpose:

- patch a world with creation/recycling logs and snapshot-printing helpers
- visualize dense-array lifetime and reuse behavior

This is diagnostic tooling, not gameplay runtime API.

### `runtime_lints`

Purpose:

- wrap world methods with clearer runtime errors
- reject obvious misuse such as setting values on tags or calling `get` on tags

This module is useful when the user wants stricter developer ergonomics than the raw ECS exports provide.

### `testkit`

Purpose:

- a general-purpose ANSI-aware test harness bundled in the repo

It is not specific to `jecs`, but it may appear in adjacent tooling or examples.

## Scope Notes On Bundled Packages

The bundled package set also contains larger adjacent tools and experiments. The most `jecs`-relevant helpers are the utilities listed above plus the networking-oriented examples. If a question is specifically about a nested bundled package, inspect that package directly instead of assuming it is part of the stable ECS core.
