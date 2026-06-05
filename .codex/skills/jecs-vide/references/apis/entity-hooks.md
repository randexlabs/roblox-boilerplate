# Entity Hooks

## Shared Patterns

These hooks all:

- accept a `Derivable` input for the entity
- return a `Vide` source
- depend on the globally bound `world`
- create subscriptions inside a `vide.effect(...)`
- register cleanup through `vide.cleanup(...)`

Shared derivable shape:

```luau
type Derivable<T> = (() -> T) | T
```

## `useEntityGet`

### Declared Surface

```ts
export function useEntityGet<T>(
    entity: Derivable<Entity | undefined>,
    id: Entity<T>,
): Source<T | undefined>;
```

Snake_case alias:

```ts
export function use_entity_get<T>(
    entity: Derivable<Entity | undefined>,
    id: Entity<T>,
): Source<T | undefined>;
```

### Runtime Behavior

- Reads the current entity through `vide.read(entity)`.
- Returns `nil` when the entity derivable resolves to `nil`.
- Subscribes to `world:added`, `world:changed`, and `world:removed` for the relevant component channel.
- Recomputes the source value when the watched component changes on the selected entity.

### Pair Handling

If `id` is a pair:

- the hook subscribes using the pair's first element
- it stores the second element for later removal checks

Special wildcard behavior:

- when a wildcard pair match is removed, the hook scans remaining targets for the same pair first-element
- it emits the first surviving matching pair value instead of always emitting `nil`

This is the most specialized hook in the package and matters for relation-heavy ECS data models.

## `useEntityHas`

### Declared Surface

```ts
export function useEntityHas<T>(
    entity: Derivable<Entity | undefined>,
    id: Entity<T>,
): Source<boolean>;
```

Snake_case alias:

```ts
export function use_entity_has<T>(
    entity: Derivable<Entity | undefined>,
    id: Entity<T>,
): Source<boolean>;
```

### Runtime Behavior

- Uses `world:has(entity, tag)` to compute the boolean state.
- Initializes the returned source immediately from the current world state.
- Subscribes to `world:added(tag, ...)` and `world:removed(tag, ...)`.
- On removal, defers the recompute with `task.defer`.

Use this for tag presence or "has component" style UI state, not for reading the component payload itself.

## `useTarget`

### Declared Surface

```ts
export function useTarget<T extends Id = Entity>(
    entity: Derivable<Entity | undefined>,
    relation: Id,
): Source<T>;
```

Snake_case alias:

```ts
export function use_target<T extends Id = Entity>(
    entity: Derivable<Entity | undefined>,
    relation: Id,
): Source<T>;
```

### Runtime Behavior

Implementation summary:

```luau
return read(entity) and exports.world:target(read(entity), relation) or nil
```

Observed meaning:

- the hook tracks the target entity of the given relation on the selected entity
- it does not read a component payload from that target
- it recomputes on `world:added(relation, ...)` and deferred `world:removed(relation, ...)`

### Type Mismatch To Preserve

The TypeScript generic suggests a broadly typed target value, but the Luau implementation reads relation target entity ids from `world:target(...)`. When answering usage questions, treat the runtime behavior as authoritative.
