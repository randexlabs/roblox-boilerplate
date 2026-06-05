# Query API

## World Query Entry Point

`world:query(...)` builds a query over zero or more IDs.

Common forms:

```luau
world:query()
world:query(Position)
world:query(Position, Velocity)
world:query(pair(Likes, alice))
world:query(Position, pair(jecs.ChildOf, parent))
```

The values returned by iteration correspond to the primary query IDs, not the `with` / `without` filters.

## Query Methods

| API                                    | Purpose                                             | Notes                                                                           |
| -------------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------------------- |
| `query:iter()`                         | Return an iterator function explicitly              | Equivalent to using the query in a `for` loop, but useful when stored manually. |
| `query:with(...)`                      | Require extra IDs without returning their values    | Good for tags or relationship guards.                                           |
| `query:without(...)`                   | Exclude entities containing the provided IDs        | Useful for state transitions and change-tracking patterns.                      |
| `query:archetypes(override?: boolean)` | Return matching archetypes                          | Use for storage-aware hot paths.                                                |
| `query:cached()`                       | Create a cached query object                        | Maintains matching archetypes incrementally.                                    |
| `query:has(entity)`                    | Check whether an entity currently matches the query | Useful for membership tests.                                                    |

## Cached Query Methods

Cached queries expose the same iteration pattern plus:

| API                                          | Purpose                                                  | Notes                                                 |
| -------------------------------------------- | -------------------------------------------------------- | ----------------------------------------------------- |
| `cachedQuery:iter()`                         | Reset iteration and return the cached iterator           | Recommended when reusing one cached query many times. |
| `cachedQuery:archetypes(override?: boolean)` | Return the cached compatible archetypes                  | Useful for archetype-specialized systems.             |
| `cachedQuery:has(entity)`                    | Fast query membership test                               | Uses the cached archetype map.                        |
| `cachedQuery:fini()`                         | Detach archetype observers and release cache bookkeeping | Important lifecycle step.                             |

## Filters

```luau
local moving = world
	:query(Position, Velocity)
	:with(Walking)
	:without(Sleeping)
```

Practical rule:

- include an ID in the base query only when you want its value yielded
- include it in `with(...)` only when presence is enough

## Relationship Queries

Exact target:

```luau
for entity, amount in world:query(pair(Eats, Apples)) do
	print(entity, amount)
end
```

Wildcard target:

```luau
for entity in world:query(pair(Eats, jecs.Wildcard)) do
	local target = world:target(entity, Eats)
end
```

Wildcard relation:

```luau
for entity in world:query(pair(jecs.Wildcard, alice)) do
	print(entity)
end
```

## Archetype-Level Iteration

`query:archetypes()` returns `Archetype` objects with:

- `id`
- `types`
- `entities`
- `columns`
- `columns_map`
- `type` string key

Typical pattern:

```luau
for _, archetype in world:query(Position, Velocity):archetypes() do
	local entities = archetype.entities
	local columns = archetype.columns_map
	local positions = columns[Position]
	local velocities = columns[Velocity]

	for row, entity in entities do
		local pos = positions[row]
		local vel = velocities[row]
	end
end
```

This is the preferred advanced path when function-call overhead or repeated target lookups dominate a hot loop.

## Important Query Caveats

- Queries iterate backwards through entity arrays.
- Cached queries attach observers and should be finalized with `fini()`.
- Wildcard matches are presence-oriented. If one entity has multiple targets for the same relation, enumerate them with `world:target(..., index)` or `world:targets(...)`.
- Relationship-heavy queries can increase fragmentation and wildcard index work, especially when many unique pairs appear.
