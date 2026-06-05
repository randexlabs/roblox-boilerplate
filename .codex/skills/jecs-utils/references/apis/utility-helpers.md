# Utility Helpers API

## `collect(event)`

Adapt an event source into a buffered iterable queue.

Declared return shape:

```luau
{
	iter = function() -> iterator,
	disconnect = function() end,
}
```

It also supports direct iteration through `__iter`.

### Accepted Runtime Shapes

The implementation accepts:

- callback-style functions that take a listener and return an optional cleanup handle
- objects with `Connect`
- objects with `connect`
- objects with `on`
- `RBXScriptSignal`

The disconnect handle may itself be:

- a cleanup function
- an object with `Disconnect`
- an object with `disconnect`
- an object with `Destroy`
- an object with `destroy`
- an `RBXScriptConnection`

### Queue Semantics

- each emitted payload is stored as an argument array
- iteration returns `index, ...payload`
- draining removes payloads from storage

## `interval(time)`

Return a closure that becomes `true` only when more than `time` seconds have elapsed since the last successful trigger.

Behavior notes:

- first call returns `false`
- internal timing uses `os.clock()`
- the pin resets only when the interval actually elapses

Example:

```luau
local everyHalfSecond = utils.interval(0.5)

if everyHalfSecond() then
	print("tick")
end
```

## `ref`

`ref` is a callable table with extra methods:

| Member                  | Meaning                                 |
| ----------------------- | --------------------------------------- |
| `ref(key, initer?)`     | Get or create the entity for `key`      |
| `ref.get(key, initer?)` | Same as calling `ref(...)`              |
| `ref.set(key, entity)`  | Force the mapping                       |
| `ref.find(key)`         | Return existing mapped entity or `nil`  |
| `ref.delete(key)`       | Remove the mapping                      |
| `ref.world(world)`      | Bind the world used for future creation |

Behavior notes:

- truthy missing keys create and store a new entity
- falsy keys create a fresh entity without storing it
- `initer(entity)` only runs when a new entity is created
- storage is module-global and persists until overwritten or deleted

## `is_a` / `IsA`

After `world(world)`, these exports point at a jecs relation id used to define parent-component propagation.

### Setup Effect

When a component is marked with `pair(is_a, parent)`:

- adding the child component mirrors the parent onto the entity
- removing the child component removes the parent
- changing the child value updates the parent value when the parent is not a tag

### Guards

The implementation asserts against directly circular inheritance:

```luau
assert(second ~= component, "circular isA inheritance")
```

### Tag Handling

If the parent component is a jecs tag, propagation uses `world:add(entity, parent)` instead of `world:set(entity, parent, value)`.
