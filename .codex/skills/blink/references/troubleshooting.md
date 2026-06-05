# Troubleshooting

## Required Output Paths Missing

Symptom:

- CLI compile fails before generation

Cause:

- `ClientOutput` or `ServerOutput` was omitted

Fix:

- define both options at the top of the schema

## Future or Promise Yield Fails

Symptom:

- generation errors when a function uses `Yield: Future` or `Yield: Promise`

Cause:

- the corresponding library path option was not provided

Fix:

- set `FutureLibrary` for `Future`
- set `PromiseLibrary` for `Promise`

## Sync Listener Misbehavior

Symptom:

- warnings about yielding in a sync call
- hard-to-debug behavior from sync event listeners

Cause:

- `SingleSync` or `ManySync` listeners yielded or errored

Fix:

- prefer async calls unless you have a real performance reason not to
- keep `SyncValidation` enabled while debugging

## Polling API Confusion

Symptom:

- generated output exposes `Iter` when the schema seems to define a normal listener

Causes:

- the event used `Call: Polling`
- the event used legacy `Poll: true`
- global `UsePolling = true` forced polling for all events

Fix:

- inspect both event fields and top-level options

## Instance Payload Drops

Symptom:

- instance values become `nil` or deserialization errors stop the rest of the payload

Cause:

- the receiving side could not resolve a non-optional `Instance`
- common reasons include streaming and sender-only instances

Fix:

- make uncertain instances optional
- avoid sending instances that are not guaranteed to exist on the receiving side

## Important Doc/Runtime Mismatches

### `Poll` Exists Even Though Docs Focus on `Call: Polling`

The parser still accepts `Poll: true` and rewrites it to polling mode. This is a compatibility path worth mentioning when reading older Blink examples.

### `UseColon` Is Parsed but Not Part of the Active Generator Surface

`UseColon` is accepted as an option by the parser, but the generator and docs do not expose meaningful behavior for it. Treat it as legacy or inactive unless you are verifying a specific historical version.

### `Next()` Exists in Luau Polling Output but Not in TypeScript Output

Generated Luau polling events expose both:

- `Iter()`
- deprecated `Next()`

Generated TypeScript declarations only document `Iter()`.

### `f16` Bounds in Prose vs Implementation

The prose docs discuss accurate integer precision around roughly `-2048..2048`, but the implementation accepts the full half-float bounds tracked in settings. This is a precision caveat, not a contradiction in supported syntax.

### Exported `Instance` and `unknown` Codecs Are Not Fully Self-Contained

The docs say exports do not support `Instance` and `unknown`. The generator does not hard-block every such declaration, but exported `Read(Buffer)` and `Write(Value)` helpers do not carry the extra instance-array channel used by the normal event transport. Treat the docs as correct for practical usage.
