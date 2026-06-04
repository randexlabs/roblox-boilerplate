# Troubleshooting

## Reactive Scope Errors

### "cannot use ... outside a stable or reactive scope"

Cause:

- a scope-dependent API such as `cleanup()` or `context()` setter was called outside Vide-managed execution

Fix:

- move the call into `root()`, `mount()`, a component body, an effect, or another Vide-managed scope

### Yielding inside Vide code

Cause:

- reactive and stable scopes are not allowed to yield

Fix:

- remove yields from property callbacks, effects, derives, and component logic
- use external scheduling around the scope rather than inside it
- keep `vide.strict = true` during development so yield violations are caught early

## Dynamic Helper Confusion

### `show()` or `switch()` returns an array sometimes

Cause:

- delayed destruction keeps an old scope alive while a new one is already present

Fix:

- treat the output as `nil`, a single object, or an array when using delayed teardown
- if you do not need transitions, return no delay so the previous scope is destroyed immediately

### `indexes()` versus `values()`

Use `indexes()` when identity is the key/index.

Use `values()` when identity is the value and items can reorder.

If `values()` receives duplicate values, strict mode raises an error because the helper uses values as identity keys.

## `create()` Sharp Edges

### Duplicate nested properties

With strict mode enabled, duplicate property assignments at the same nesting depth error out.

This usually means a nested property table assigned the same property more than once.

### Cloning from an instance fails

Cause:

- `create(existingInstance)` clones the instance, so non-archivable instances fail

Fix:

- use an archivable template instance
- or create by class name instead

### Events versus reactive properties

A string property assigned a function does one of two things:

- if the property is an event, Vide connects it as a listener
- otherwise, Vide treats it as a reactive property producer

If a callback is not firing as an event, verify that the key names a real event on the instance.

## Context Failures

### Getting a context value errors

Cause:

- the context has no active provider and no default value

Fix:

- create the context with a default value
- or ensure the read happens inside the provider callback

### Setting context outside a scope

Cause:

- provider form `ctx(value, fn)` was called without an active Vide scope

Fix:

- call it from within `root()`, `mount()`, a component body, or another Vide-managed scope

## Runtime Mismatches Worth Remembering

- The changelog says old `create()` overloads are deprecated, but runtime still supports them.
- The basic API docs understate the callback parameters for `show()`, `switch()`, `indexes()`, and `values()`.
- `indexes()` and `values()` return sources of arrays, not plain arrays.
- `vide.step(dt)` permanently disables the automatic Heartbeat-driven stepping for the current loaded runtime after first manual use.
- `vide.apply` is exported as a temporary helper even though it is not a central documented API.
