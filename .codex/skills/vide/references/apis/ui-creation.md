# UI Creation API

## `create(classOrInstance, props?)`

Vide currently supports both the modern curried form and legacy overloads.

```luau
function create(className: string): (props: Properties) -> Instance
function create(className: string, props: Properties): Instance
function create(template: Instance): (props: Properties) -> Instance
function create(template: Instance, props: Properties): Instance
```

Notes:

- the changelog marks the non-curried overloads as deprecated, but they still work at runtime
- passing an instance clones it, so the template must be archivable
- invalid class names error immediately

## Property Table Semantics

`create()` delegates to the same semantics exposed by `vide.apply`.

### String keys

- non-function values are assigned directly
- function values are interpreted as:
    - event listeners when the target member is an event
    - reactive property producers otherwise
- `Parent` is deferred until after events and actions

### Numeric keys

- `Action` values run custom logic against the created instance
- table values become nested property/child groups
- function values become reactive child producers
- instance values become children by parenting
- `false` children are ignored by runtime behavior

## Ordering Rules

The effective order is:

1. process property entries
2. queue event connections
3. queue actions by priority
4. connect events
5. run actions from lower priority to higher priority
6. apply parent assignment or reactive parent binding

This matters when an action depends on event connections already existing or when parenting should happen after instance preparation.

## Nested Property Handling

Nested tables are supported.

- `vide.defer_nested_properties` controls whether nested tables are deferred and processed after the current layer
- with strict mode enabled, duplicate property assignments at the same nesting depth error out

## `mount(component, target?)`

```luau
function mount<T>(component: () -> T, target: Instance?): () -> ()
```

Behavior:

- creates a stable root scope
- runs the component once
- if `target` is given, applies the result to `target` using full Vide `apply()` semantics
- returns a destroy function for the created scope

`mount()` is mainly a convenience wrapper around `root()`.

## `action(callback, priority?)`

Creates a tagged action object that `create()` recognizes in numeric child slots.

```luau
function action(callback: (instance: Instance) -> (), priority: number?): Action
```

Behavior:

- lower priorities run first
- default priority is `1`
- actions run after event connections are established

Use actions for imperative setup that should still be scope-owned and composition-friendly.

## `changed(property, callback)`

Convenience wrapper around `action()`.

```luau
function changed<T>(property: string, callback: (value: T) -> ()): Action
```

Behavior:

- subscribes to `GetPropertyChangedSignal(property)`
- disconnects automatically on cleanup
- invokes `callback` immediately with the initial property value

## `apply(instance)(props)` and `apply(instance, props)`

The exported `vide.apply` is a temporary helper.

Public runtime shape:

```luau
function apply(instance: Instance): (props: Properties) -> Instance
```

Internally it delegates to the full property-processing engine used by `create()`.

Use it when you need Vide property semantics on an existing instance, but treat it as a compatibility helper rather than the main authored style.
