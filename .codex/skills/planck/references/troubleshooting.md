# Troubleshooting

## `PlanckRunService.new()` does not exist

In the Luau runtime you supplied, `planck_runservice` exports a table:

- `Plugin`
- `Phases`
- `Pipelines`

So the Luau shape is:

```luau
local PlanckRunService = require("@packages/PlanckRunService")
local plugin = PlanckRunService.Plugin.new()
```

The docs sometimes show `PlanckRunService.new()`. Treat the runtime export shape as authoritative.

## `PlanckJabby.Plugin.new()` does not exist

`planck_jabby` is the opposite shape from `planck_runservice` in the supplied runtime: it exports the plugin directly.

Use:

```luau
local PlanckJabby = require("@packages/PlanckJabby")
local plugin = PlanckJabby.new()
```

Not:

```luau
PlanckJabby.Plugin.new()
```

## `onEvent` returns more than the typings suggest

The public `.d.ts` describes two return values:

- `hasNewEvent`
- `collectEvents`

But the Luau runtime and docs also expose a third return:

- `getDisconnectFn`

So in Luau the runtime shape is effectively:

```luau
local hasNewEvent, collectEvents, getDisconnectFn = Planck.onEvent(signal)
```

If you need manual teardown, use the third return in Luau or rely on scheduler-driven cleanup when the condition is only attached through scheduler APIs.

## Hook docs mention `SystemEdited`, but typings may not

The runtime hook table includes `SystemEdited`, and the Jabby plugin uses it.

If your typings do not expose it cleanly, that is a docs/typing mismatch rather than absence from the scheduler runtime.

## `Scheduler:getDeltaTime()` errors

Cause:

- it was called outside a registered system execution

Planck expects this method to be used while a scheduler-run system is active. It is not a general clock API.

## A system never runs

Common causes:

- it was added without a phase that ever runs
- the user expected `addSystem` alone to start event execution, but no event-bound phases/plugins are driving it
- a run condition returns falsy
- the system was only inserted into startup phases and already exhausted its one-time execution

Checks:

- verify the phase or pipeline is inserted
- verify the relevant event plugin is installed
- verify conditions return truthy when expected
- verify whether the system is in a startup-only phase

## Systems inside call hooks stop executing

Cause:

- a plugin hook on `OuterSystemCall`, `InnerSystemCall`, or `SystemCall` failed to call `context.nextFn()`

Rule:

- the hook callback must return a function
- that returned function must call `context.nextFn()`

These hooks are wrapping hooks, not cancellation hooks.

## Plugin cleanup surprises

The scheduler warns that some debugger-style plugins are not fully safe for throwaway schedulers. The docs explicitly caution against assuming all plugins clean up perfectly.

Practical implication:

- use `scheduler:cleanup()` when discarding the scheduler
- do not assume every external integration becomes perfectly collectible afterward

## Private members look tempting in plugins

The plugin docs explicitly warn against using `_private` scheduler members.

Exception:

- internal official plugins do it where necessary

For user code, treat `_` members as unstable implementation detail even across minor or patch releases.

## Event binding confusion with `insertAfter` and `insertBefore`

When you order a phase/pipeline relative to another event-bound target, the dependent inherits the event group of the dependency.

This can be surprising if you thought you were only expressing order. You may also be moving the target into a different event group implicitly.
