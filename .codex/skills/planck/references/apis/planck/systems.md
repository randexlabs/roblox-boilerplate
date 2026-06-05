# `planck` Systems

## Accepted System Shapes

Planck accepts three practical system forms:

| Shape                                                            | Description        |
| ---------------------------------------------------------------- | ------------------ |
| `function(...args)`                                              | Plain system       |
| `function(...args) -> runtimeFn`                                 | Initializer system |
| `{ system = ..., name = ..., phase = ..., runConditions = ... }` | System table       |

## Initializer Systems

Initializer systems may return:

```luau
return runtimeFn
```

Or:

```luau
return runtimeFn, cleanupFn
```

Or the structured typed equivalent where `system` and `cleanup` are fields.

Behavior:

- setup runs once on the first execution
- the returned runtime system runs immediately that same execution
- subsequent executions run only the runtime function
- cleanup runs on `removeSystem` and for replaced systems when applicable

## System Table Fields

| Field           | Type                               | Notes                                     |
| --------------- | ---------------------------------- | ----------------------------------------- |
| `system`        | required function                  | Plain or initializer system               |
| `name`          | optional string                    | Helpful for debugging and tooling         |
| `phase`         | optional `Phase`                   | Defaults to the scheduler’s default phase |
| `runConditions` | optional array/tuple of conditions | All must pass for execution               |

## Public Types

Relevant exported package-level types:

- `System`
- `SystemFn`
- `SystemTable`
- `InitializerSystemFn`
- `InitializerResult`
- `CleanupFn`

## `SystemInfo`

`SystemInfo` is the main metadata object plugins work with.

Important fields:

- `system`
- `run`
- `cleanup`
- `initialized`
- `name`
- `phase`
- `logs`
- `recentLogs`
- timing/logging fields used by runtime instrumentation

The plugin docs treat this as intentionally usable plugin-facing information, unlike `_private` scheduler members.
