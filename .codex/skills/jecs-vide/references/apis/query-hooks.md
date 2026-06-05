# Query Hooks

## Shared Query Dependency

Both query hooks accept a derivable query and rely on `jecs-utils.monitor(query)` for change notifications.

That means their behavior depends on query membership changes, not on every raw world event.

## `useQueryFirst`

### Declared Surface

```ts
export function useQueryFirst<T extends Id[]>(
    query: Derivable<Query<T>>,
    predicator?: (entity: Entity, ...components: InferComponents<T>) => boolean,
): Source<Entity | undefined>;
```

Snake_case alias:

```ts
export function use_query_first<T extends Id[]>(
    query: Derivable<Query<T>>,
    predicator?: (entity: Entity, ...components: InferComponents<T>) => boolean,
): Source<Entity | undefined>;
```

### Runtime Behavior

- Resolves the query through `vide.read(query)`.
- Returns `nil` immediately when the derivable resolves to `nil`.
- Creates a monitor for the resolved query.
- Recomputes the first matching entity on every monitor `added` or `removed` signal.
- Disconnects the monitor through `vide.cleanup`.

The implementation recomputes through:

```luau
jecs_utils.query_first(queryobj, predicator)
```

### Predicate Notes

- The public TypeScript name is `predicator`.
- The predicate receives the entity followed by the query's component values.
- "First" depends on the underlying query iteration order and the predicate outcome.

## `useQuery`

### Declared Surface

```ts
export function useQuery(query: Derivable<Query<Id[]>>): Source<Entity[]>;
```

Snake_case alias:

```ts
export function use_query(query: Derivable<Query<Id[]>>): Source<Entity[]>;
```

### Runtime Behavior

- Resolves the query through `vide.read(query)`.
- If the query is `nil`, clears the entity list and emits an empty array.
- Otherwise, populates the list from `query:iter()`.
- Then subscribes to monitor add/remove events for incremental maintenance.

### Internal Data Structure

The hook maintains:

```luau
local entities = {} :: { jecs.Entity }
local entity_map = {} :: { [jecs.Entity]: number }
```

`entity_map` stores the current index of each entity in the array so removal can happen in O(1).

### Removal Semantics

Removals are deferred and processed with swap-remove:

1. Look up the entity index.
2. Remove the last array element.
3. If the removed entity was not already the last element, move that last entity into the vacated index.
4. Update the moved entity's index in `entity_map`.

Practical consequences:

- entity order is not stable
- deletion is efficient
- the same `entities` array object is mutated and re-emitted

### Consumer Guidance

Use `useQuery` when you want an efficient live list of query members. If the consumer needs:

- stable order: sort or copy the array in the consuming layer
- immutable snapshots: clone the array before passing it into identity-sensitive code
