# `planck` Plugins And Hooks

## Core Plugin Interface

The core package exposes a `Plugin` interface shape conceptually like:

| Member             | Required | Purpose                             |
| ------------------ | -------- | ----------------------------------- |
| `build(scheduler)` | yes      | Install behavior into the scheduler |
| `cleanup()`        | optional | Tear down plugin-owned resources    |

In Luau, official plugins also expose `new()` constructors, even though the top-level interface in typings mainly emphasizes `build` and optional `cleanup`.

## Adding A Plugin

```luau
scheduler:addPlugin(myPlugin)
```

The scheduler calls the plugin’s `build` method internally.

## Hook Registration

| API                              | Purpose                  | Notes                                         |
| -------------------------------- | ------------------------ | --------------------------------------------- |
| `scheduler:addHook(hookId, fn)`  | Register a hook callback | Preferred API                                 |
| `scheduler:_addHook(hookId, fn)` | Deprecated alias         | Kept for compatibility; docs advise `addHook` |

## Runtime Hook IDs

Observed runtime hook set:

- `SystemAdd`
- `SystemRemove`
- `SystemReplace`
- `SystemEdited`
- `SystemCleanup`
- `SystemError`
- `SystemTriedRun`
- `OuterSystemCall`
- `InnerSystemCall`
- `SystemCall`
- `PhaseAdd`
- `PhaseBegan`

`SystemEdited` is important because it exists in runtime and plugin code even when some typings or summaries may omit it.

## Hook Context Families

| Context                | Key fields                                |
| ---------------------- | ----------------------------------------- |
| `SystemHookContext`    | `scheduler`, `system`                     |
| `SystemReplaceContext` | `scheduler`, `old`, `new`                 |
| `SystemEditedContext`  | `scheduler`, `system`, `old`, `new` phase |
| `SystemErrorContext`   | `scheduler`, `system`, optional `error`   |
| `SystemCallContext`    | `scheduler`, `system`, `nextFn`           |
| `PhaseContext`         | `scheduler`, `phase`                      |
