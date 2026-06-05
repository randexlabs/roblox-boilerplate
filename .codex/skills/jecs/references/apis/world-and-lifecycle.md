# World And Lifecycle API

## World Construction

| API                               | Purpose               | Notes                                                         |
| --------------------------------- | --------------------- | ------------------------------------------------------------- |
| `jecs.world(debug?: boolean)`     | Create a world        | `true` enables stronger assertions and invalid-handle checks. |
| `jecs.World.new(debug?: boolean)` | Alternate constructor | Same runtime behavior as `jecs.world(...)`.                   |

## Top-Level ID Constructors

| API                                 | Purpose                                                | Notes                                                                |
| ----------------------------------- | ------------------------------------------------------ | -------------------------------------------------------------------- |
| `jecs.component<T>() -> Entity<T>`  | Forward-declare a component ID before world creation   | Must run before `jecs.world()` if the world should auto-register it. |
| `jecs.tag() -> Entity<nil>`         | Forward-declare a tag ID                               | Same preregistration rule as `jecs.component()`.                     |
| `jecs.meta(id, metaId, value?)`     | Attach forward-declared metadata to a preregistered ID | Most commonly used with `jecs.Name`.                                 |
| `jecs.is_tag(world, id) -> boolean` | Check whether an ID is a tag                           | Works for normal IDs and relationship-first IDs.                     |

## Entity And Component Allocation

| API                        | Purpose                                                      | Notes                                                               |
| -------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------- |
| `world:entity()`           | Create a new entity handle                                   | Returns a live entity with no components.                           |
| `world:entity(id)`         | Force/ensure a specific entity ID                            | Useful for deserialization or reserved IDs.                         |
| `world:component<T>()`     | Allocate a data-bearing component in the low component range | Preferred runtime path for normal components.                       |
| `world:range(begin, end?)` | Restrict the allowed created-entity range                    | Used when a project wants entity allocation within a specific band. |

## Core Mutation API

| API                            | Purpose                                            | Notes                                           |
| ------------------------------ | -------------------------------------------------- | ----------------------------------------------- |
| `world:add(entity, id)`        | Add a tag or presence-only ID                      | Do not pass a value.                            |
| `world:set(entity, id, value)` | Add or update a data-bearing ID                    | Also works for pair payloads.                   |
| `world:remove(entity, id)`     | Remove one ID from one entity                      | Triggers `OnRemove` and removed listeners.      |
| `world:clear(entity)`          | Remove all IDs from one entity                     | Entity remains alive.                           |
| `world:delete(entity)`         | Delete an entity entirely                          | Cleanup policies may cascade to other entities. |
| `world:cleanup()`              | Remove empty archetypes and rebuild archetype maps | Mostly useful after heavy churn.                |

## Read And Presence API

| API                                        | Purpose                                      | Notes                                                      |
| ------------------------------------------ | -------------------------------------------- | ---------------------------------------------------------- |
| `world:get(entity, id1, id2?, id3?, id4?)` | Read up to four component values             | Values are nullable because presence is runtime-dependent. |
| `world:has(entity, id1, ...)`              | Test whether the entity has all provided IDs | Preferred for tags and relationship presence checks.       |
| `world:contains(entity)`                   | Check whether this exact handle is alive     | Detects stale generations.                                 |
| `world:exists(entity)`                     | Check whether an entity slot/record exists   | Weaker than `contains` for stale-handle concerns.          |

## Hierarchy And Relationship Traversal

| API                                      | Purpose                                              | Notes                                                               |
| ---------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------- |
| `world:parent(entity)`                   | Return the target of `pair(jecs.ChildOf, parent)`    | Returns `nil` if there is no such relation.                         |
| `world:children(id)`                     | Iterate children of an ID                            | Convenience helper over `ChildOf` relationships.                    |
| `world:each(id)`                         | Iterate entities that have a single ID               | Useful for tags, components, or pair IDs.                           |
| `world:target(entity, relation, index?)` | Return the Nth target for a relation on an entity    | Index is zero-based.                                                |
| `world:targets(entity, relation)`        | Return an iterator over all targets for one relation | Better than repeated wildcard re-querying when enumerating targets. |

## Hooks

Hooks are configured by setting built-in trait IDs on the component entity:

| Hook Trait      | Signature                                  | Purpose                                                                |
| --------------- | ------------------------------------------ | ---------------------------------------------------------------------- |
| `jecs.OnAdd`    | `(entity, id, value, oldArchetype?) -> ()` | Fires when the component is first added with a value or presence.      |
| `jecs.OnChange` | `(entity, id, value, oldArchetype?) -> ()` | Fires when an existing component value changes.                        |
| `jecs.OnRemove` | `(entity, id, delete?) -> ()`              | Fires when the ID is removed; `delete` is true during entity deletion. |

Example:

```luau
world:set(Health, jecs.OnRemove, function(entity, id, delete)
	if delete then
		return
	end

	world:remove(entity, Dead)
end)
```

## Signals

Signals let multiple listeners observe lifecycle events for one component or relation.

| API                     | Signature                                 | Notes                          |
| ----------------------- | ----------------------------------------- | ------------------------------ |
| `world:added(id, fn)`   | `(entity, id, value, oldArchetype) -> ()` | Returns a disconnect function. |
| `world:changed(id, fn)` | `(entity, id, value, oldArchetype) -> ()` | Returns a disconnect function. |
| `world:removed(id, fn)` | `(entity, id, delete?) -> ()`             | Returns a disconnect function. |

Observed behavior from the implementation:

- the first subscription for a given ID installs a dispatch hook into the component record
- an existing hook on that ID is preserved by being added into the listener list
- disconnecting twice errors because the listener is no longer present
