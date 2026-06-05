# Generated Luau API

## Module Shape

Generated modules return an immutable table created with `table.freeze`.

The table contains:

- one entry per event
- one entry per function
- nested tables for scopes and imports
- `StepReplication`
- type exports
- exported serializer helpers for `export` declarations

## Environment Restrictions

Client module:

- errors if required outside the client
- waits for the Blink remotes in `ReplicatedStorage`

Server module:

- errors if required outside the server
- creates the Blink remotes in `ReplicatedStorage` if missing

## Event APIs

Receive-side event surface depends on direction and polling mode.

## Client-Owned Event

Server output receives:

- `On(listener)` for callback mode
- `Iter()` and deprecated `Next()` for polling mode

Client output sends:

- `Fire(...)`

## Server-Owned Event

Client output receives:

- `On(listener)` for callback mode
- `Iter()` and deprecated `Next()` for polling mode

Server output sends:

- `Fire(player, ...)`
- `FireAll(...)`
- `FireList(players, ...)`
- `FireExcept(player, ...)`

## Listener Return Value

`On(listener)` returns a disconnect function.

Reliable callback-mode events queue up to 256 unread packets before warning that no listener may be attached.

## Polling Events

Generated polling events expose:

- `Iter()`
- deprecated `Next()`

`Iter()` returns an iterator over queued payload tuples.

Server-side polling tuples include `Player` as the first payload item after the loop index for client-originated traffic.

## Function APIs

Functions always ride reliable traffic.

Server output exposes:

- `On(listener)`

Client output exposes:

- `Invoke(...)`

`Invoke(...)` return shape depends on `Yield`:

- `Coroutine`: direct Luau returns
- `Future`: future instance from the configured library
- `Promise`: promise instance from the configured library

## `StepReplication`

Always exported.

Behavior:

- flushes reliable buffered traffic
- does nothing if there is nothing queued
- is also auto-connected to `Heartbeat` unless `ManualReplication = true`

Important distinction:

- reliable event fires buffer until replication
- unreliable event fires send immediately

## Exported Type Codecs

For `export` declarations, Blink emits:

```luau
Name = {
    Read = function(Buffer) ... end,
    Write = function(Value) ... end,
}
```

Practical constraints:

- best for plain serialized data
- not a replacement for full event transport when data depends on the instance side-channel

## Generated Type Names

Named declarations also become `export type` aliases.

Scoped names are flattened in type exports using underscore separators, for example:

- runtime path: `Blink.Inventory.Item`
- type name: `Blink.Inventory_Item`
