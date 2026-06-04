# Flags And Types

## Global Flags

Vide exposes three library-wide runtime flags through properties on the exported table.

### `vide.strict`

```luau
vide.strict = boolean
```

Default behavior:

- enabled automatically when Vide is loaded outside O2 optimization
- disabled automatically in O2 production builds unless manually forced on

What it does:

- reruns reactive scopes twice on updates to catch impurity
- errors on illegal yields
- checks `indexes()` and `values()` misuse
- checks duplicate nested properties
- checks destruction of an active scope
- improves diagnostics and stack traces

Recommended use:

- keep enabled during development
- rely on production optimization defaults unless you intentionally want strict checks live

### `vide.defaults`

```luau
vide.defaults = boolean
```

Default: `true`

Behavior:

- when enabled, class-name construction through `create("ClassName")` applies library-defined default properties for supported classes before user properties

Use this flag if you need to disable Vide's built-in defaults and work from raw Roblox instance defaults instead.

### `vide.defer_nested_properties`

```luau
vide.defer_nested_properties = boolean
```

Default: `true`

Behavior:

- controls whether nested property tables are buffered and processed after the current property layer instead of immediately recursing

This mainly affects advanced property-application ordering.

## Public Type Aliases

Vide re-exports these aliases:

```luau
export type Source<T> = (() -> T) & ((value: T) -> T)
export type source<T> = Source<T>

export type Context<T> = (() -> T) & (<U>(value: T, component: () -> U) -> U)
export type context<T> = Context<T>
```

Notes:

- lowercase aliases are synonyms of the uppercase aliases
- the lowercase names match the runtime constructor names

## Missing Or Non-Public Items

Some internal helpers exist but are not part of the intended public surface:

- `branch`
- timeout internals
- graph internals

Do not present those as normal application APIs unless the question is specifically about Vide internals.
