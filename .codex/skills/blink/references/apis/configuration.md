# Configuration API

## File Options

Options use:

```blink
option Name = Value
```

## `Casing`

Accepted values:

- `Pascal`
- `Camel`
- `Snake`

Controls generated method names for:

- `Fire`
- `FireAll`
- `FireList`
- `FireExcept`
- `On`
- `Invoke`
- `StepReplication`
- `Next`
- `Iter`
- `Read`
- `Write`

## `ClientOutput`

String path for the generated client Luau module.

Required by the CLI compile path.

## `ServerOutput`

String path for the generated server Luau module.

Required by the CLI compile path.

## `TypesOutput`

Optional string path for a shared Luau output containing type exports and exported serializers without event/function declarations.

## `Typescript`

Boolean flag enabling `.d.ts` generation for client and server outputs.

Behavior:

- declaration files are written beside the generated Luau outputs
- `init.luau` maps to `index.d.ts`

## `UsePolling`

Boolean flag that forces all events to expose polling APIs on the receive side, regardless of each event's `Call`.

This affects both generated Luau and generated TypeScript declarations.

## `FutureLibrary`

String require path for the future library used by `Yield: Future`.

Generation errors if a function uses `Future` and this option is missing.

## `PromiseLibrary`

String require path for the promise library used by `Yield: Promise`.

Generation errors if a function uses `Promise` and this option is missing.

## `SyncValidation`

Boolean flag controlling whether sync calls track accidental yielding.

Default:

- `true` when omitted

Effect:

- generated runtime tracks the current sync call and warns if the listener yields

## `WriteValidations`

Boolean flag enabling extra type checks on writes.

Behavior:

- built-in validations run on reads already
- additional write-time validations are only generated when this option is `true`
- docs explicitly warn that only builtin primitives are checked well

## `ManualReplication`

Boolean flag controlling whether generated reliable replication auto-flushes on `Heartbeat`.

Behavior:

- `false`: `Heartbeat:Connect(StepReplication)` is generated
- `true`: manual stepping only

## `RemoteScope`

String prefix used for the shared remote names.

Default naming:

- reliable: `BLINK_RELIABLE_REMOTE`
- unreliable: `BLINK_UNRELIABLE_REMOTE`

With `RemoteScope = "PACKAGE"`:

- reliable: `PACKAGE_BLINK_RELIABLE_REMOTE`
- unreliable: `PACKAGE_BLINK_UNRELIABLE_REMOTE`

Runtime protection:

- generated non-shared modules register the scope in `_G._BLINK`
- requiring another generated Blink module with the same remote scope errors

## Parsed but Inactive or Legacy Options

## `UseColon`

The parser accepts `UseColon` as a boolean option, but the active docs and generator surface do not expose meaningful behavior for it. Treat it as legacy or unused unless you are auditing older Blink versions.
