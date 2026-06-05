# `planck` Conditions

## Base Type

| API                  | Purpose                                                       |
| -------------------- | ------------------------------------------------------------- |
| `Condition<...args>` | Function returning truthy or falsy to allow or skip execution |

If any run condition on a system, phase, or pipeline returns falsy, execution is skipped for that target.

## Scheduler Attachment

`scheduler:addRunCondition(...)` supports three target categories:

| Target     | Meaning                                                    |
| ---------- | ---------------------------------------------------------- |
| `system`   | Condition gates that system                                |
| `phase`    | Condition gates all systems in that phase                  |
| `pipeline` | Condition gates all systems in all phases of that pipeline |

## `timePassed`

| API                   | Purpose                                              |
| --------------------- | ---------------------------------------------------- |
| `timePassed(seconds)` | Throttle execution until enough time has accumulated |

## `runOnce`

| API         | Purpose                           |
| ----------- | --------------------------------- |
| `runOnce()` | Allow the target to run only once |

## `onEvent`

Documented/runtime-supported forms include:

| Form                     | Typechecked? | Example                                 |
| ------------------------ | ------------ | --------------------------------------- |
| direct RBXScriptSignal   | yes          | `onEvent(Players.PlayerAdded)`          |
| instance + event object  | yes          | `onEvent(Players, Players.PlayerAdded)` |
| instance + string name   | no           | `onEvent(Players, "PlayerAdded")`       |
| signal-like object       | yes          | `onEvent(mySignal)`                     |
| table + string method    | no           | `onEvent(t, "connect")`                 |
| table + method reference | yes          | `onEvent(t, t.connect)`                 |

Runtime/docs shape:

```luau
local hasNewEvent, collectEvents, getDisconnectFn = Planck.onEvent(signal)
```

Meaning:

- `hasNewEvent`: condition function suitable for `addRunCondition`
- `collectEvents`: returns an iterator over queued event payloads
- `getDisconnectFn`: returns a disconnect function for manual cleanup

The supplied typings only describe the first two values, so treat the third as a documented/runtime extension in Luau.

## `isNot`

| API                     | Purpose                  |
| ----------------------- | ------------------------ |
| `isNot(condition, ...)` | Invert another condition |
