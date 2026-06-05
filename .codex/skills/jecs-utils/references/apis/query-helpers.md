# Query Helpers API

## `query_first(query, predicator?)`

Return the first entity from `query:iter()`.

If `predicator` is supplied, the helper keeps iterating until the predicate returns `true`.

```luau
local entity, health = utils.query_first(query, function(entity, health)
	return health > 0
end)
```

Behavior notes:

- returns the entity plus component values from the query
- returns `nil` if the query is empty
- also returns `nil` if the predicate rejects every candidate
- the parameter name is spelled `predicator` in the declarations and comments

## `query_count(query)`

Count matches by summing the size of each matching archetype's `entities` array.

Behavior notes:

- avoids iterating each entity manually
- ignores component values and only reads archetype membership

## `query_entities(query)`

Gather every matching entity id into a plain array.

Behavior notes:

- uses `table.move` to append entire archetype entity arrays
- returns entities only, not component values

## `query_random(query)`

Return one random matching entity and its component values.

Behavior notes:

- computes total query size across archetypes
- samples one row with `math.random(1, size)`
- returns `nil` if the query is empty
- fast-paths explicit component unpacking for up to 8 query ids
- falls back to a generic path for larger query id lists

This helper preserves query component return order.

## `query_changed(query)`

Create a queue of entities whose relevant query terms changed while they matched the query.

Return shape:

| Member                   | Meaning                                      |
| ------------------------ | -------------------------------------------- |
| `iter()`                 | Drain current queued entities as an iterator |
| `empty()`                | Check whether the queue is currently empty   |
| `disconnect()`           | Stop internal subscriptions                  |
| `for entity in queue do` | Supported through `__iter` metamethod        |

Behavior notes:

- deduplicates queued entities until drained
- removes entities from the queue if they stop matching before drain
- draining resets the queue

## `query_monitor(query)`

Create queued iterators for query membership changes.

Return shape:

| Member         | Meaning                              |
| -------------- | ------------------------------------ |
| `added()`      | Drain entities that started matching |
| `removed()`    | Drain entities that stopped matching |
| `disconnect()` | Stop internal subscriptions          |

Behavior notes:

- deduplicates per queue
- if an entity enters and leaves before drain, the helper cancels the opposite-side pending entry where possible
- each drain call resets only its own queue
