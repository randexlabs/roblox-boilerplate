# Reactivity API

## Core Scope APIs

### `root(fn)`

Runs `fn` in a new stable scope.

```luau
function root<T...>(fn: (destroy: () -> ()) -> T...): (() -> (), T...)
```

Behavior:

- returns the destroy function first, followed by `fn`'s returned values
- child scopes created inside the root are owned by that root
- if an error occurs while running the root callback, the scope is cleaned up

### `source(initialValue?)`

Creates a writable source.

```luau
function source<T>(initialValue: T): Source<T>
function source<T>(): Source<T>

type Source<T> = (() -> T) & ((value: T) -> T)
```

Behavior:

- call with no arguments to read
- call with one argument to write
- the setter returns the value that was written
- equal primitive values and equal frozen tables do not trigger updates
- mutable tables are treated conservatively, so writing the same unfrozen table reference still propagates

### `effect(fn)`

Runs `fn` in a reactive scope immediately and reruns it when tracked sources change.

```luau
function effect(fn: () -> ())
function effect<T>(fn: (previous: T) -> T, initialValue: T)
```

Notes:

- the second overload exists in the runtime typing
- reactive scopes may not directly create other reactive scopes

### `derive(fn)`

Creates a cached derived source.

```luau
function derive<T>(fn: () -> T): () -> T
```

Use this when a computed value will be read multiple times between updates.

## Utility Reactivity APIs

### `cleanup(value)`

Registers cleanup for the current scope.

```luau
function cleanup(value: (() -> ()) | thread | Disconnectable | Destroyable)
```

Accepted object forms include lowercase and uppercase method names:

- `disconnect()` or `Disconnect()`
- `destroy()` or `Destroy()`

### `untrack(fn)`

Runs a callback in a stable scope so reactive reads inside it are not tracked by the current reactive scope.

```luau
function untrack<T>(fn: () -> T): T
function untrack(fn: () -> ()): ()
```

Use it to insert a stable boundary inside a reactive computation.

### `read(value)`

Reads either a raw value or a source-like function.

```luau
function read<T>(value: T | () -> T): T
```

### `batch(fn)`

Defers downstream reactive flushing until `fn` completes.

```luau
function batch(fn: () -> ())
```

Useful when multiple sources feed the same effects.

### `context(defaultValue?)`

Creates a context accessor/provider function.

```luau
function context<T>(defaultValue: T): Context<T>
function context<T>(): Context<T>

type Context<T> = (() -> T) & (<U>(value: T, component: () -> U) -> U)
```

Getter behavior:

- `ctx()` walks up scope ownership looking for a provider
- if no provider exists and a default was given, the default is returned
- if no provider and no default exist, it errors

Provider behavior:

- `ctx(value, fn)` creates a new scope-local provider
- it must run inside an active Vide scope
- `nil` can be provided explicitly; the runtime preserves that case internally
- the provider returns whatever `fn` returns

## Dynamic Control Flow APIs

These helpers all create internal reactive logic and stable child scopes.

### `show(input, component, fallback?)`

Runtime behavior is richer than the basic docs suggest.

```luau
function show<T, Obj>(
    input: () -> T?,
    component: (current: () -> T, present: () -> boolean) -> (Obj, ...number),
    fallback: ((present: () -> boolean) -> (Obj, ...number))?
): () -> nil | Obj | { Obj }
```

Behavior:

- `component` receives a source containing the latest truthy input value
- `present` is a boolean source indicating whether the branch is currently considered active
- returning an additional number delays destruction for transitions
- output can be `nil`, one object, or an array during overlap windows

### `switch(input)(map)`

```luau
function switch<K, Obj>(
    input: () -> K
): (map: { [K]: ((present: () -> boolean) -> (Obj, ...number)) }) -> (() -> nil | Obj | { Obj })
```

Behavior:

- creates one stable scope per active key
- if a branch returns a delay, previous keyed scopes may remain alive temporarily
- when a previously delayed scope becomes active again, destruction is canceled

### `indexes(input, component)`

```luau
function indexes<K, V, Obj>(
    input: () -> { [K]: V },
    component: (value: () -> V, index: K, present: () -> boolean) -> (Obj, ...number)
): () -> { Obj }
```

Behavior:

- identity is keyed by the table index/key
- existing keyed scopes persist and their value source updates when the value changes
- removed keys can be destroyed immediately or after a delay
- returns a source of the currently active objects

### `values(input, component)`

```luau
function values<K, V, Obj>(
    input: () -> { [K]: V },
    component: (value: V, index: () -> K, present: () -> boolean) -> (Obj, ...number)
): () -> { Obj }
```

Behavior:

- identity is keyed by the value itself
- the component receives the raw value plus a source of its current index/key
- strict mode rejects duplicate values in the input table
- best suited for stable objects that may reorder
