# Conceptual Guides

## Blink Is Schema-First

You do not hand-register remotes or callbacks in Blink itself. You describe the protocol, then work only against the generated modules.

This means:

- declaration mistakes fail at compile time or generation time
- runtime APIs are shaped entirely by the schema
- changing `Casing`, polling, or scope structure changes the output surface

## Events vs Functions

Use events for one-way traffic:

- server to client notifications
- client to server intents
- unreliable high-frequency traffic

Use functions for client-to-server request/response flows:

- server lookups
- authority-checked actions needing a response
- cases where the client expects a returned value

Functions are implemented over reliable traffic with invocation identifiers. They are not Roblox `RemoteFunction`, so yield semantics depend on Blink's generated machinery.

## Reliable vs Unreliable

Reliable traffic:

- is buffered until replication runs
- preserves ordering
- is used for functions
- supports queued listeners when no callback is attached yet

Unreliable traffic:

- sends immediately from the exposed fire method
- has a practical packet ceiling documented as 1000 bytes
- does not queue listeners the same way reliable polling does

## Replication Model

Generated code always exposes `StepReplication`.

Behavior depends on `ManualReplication`:

- `false`: generated modules also connect `StepReplication` to `RunService.Heartbeat`
- `true`: no automatic heartbeat connection is installed, so the caller must step replication manually

This is especially important when you want deterministic flush timing or you need to align networking with a custom frame phase.

## Scopes and Imports

Scopes and imports both affect the generated table structure.

- `scope Foo { ... }` creates `Blink.Foo.*` members and prefixed Luau type names such as `Blink.Foo_BarType`
- `import "./common"` behaves similarly, with the imported file mounted under its filename or explicit `as` alias
- nested scopes capture parent definitions, so inner declarations can reference outer ones

The easiest way to think about imports is "file-backed scopes".

## Polling Mental Model

Polling events are receive-side queue readers instead of callback listeners.

- explicit `Call: Polling` enables it per event
- `UsePolling = true` forces polling APIs for all events
- generated Luau provides `Iter()`
- generated Luau also provides deprecated `Next()` for compatibility

Polling is most useful when you want to drain events inside a controlled update loop instead of reacting through callbacks.

## Type Exports

`export` on a non-generic type emits standalone `Read(Buffer)` and `Write(Value)` helpers.

Use this when you want:

- reusable codecs for data outside the main event surface
- buffer serialization for custom systems
- access to generated type aliases without wiring a whole event around them

Do not treat exported serializers as equivalent to full event serialization for `Instance` or `unknown` payloads. Those runtime types rely on an instance side-channel in normal event transport.
