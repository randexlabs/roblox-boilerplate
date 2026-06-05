# `planck_runservice` Plugin

## `Plugin`

| API                       | Purpose                                                       |
| ------------------------- | ------------------------------------------------------------- |
| `Plugin.new()`            | Construct the RunService integration plugin                   |
| `plugin:build(scheduler)` | Install built-in pipelines and phases onto the scheduler      |
| `plugin:cleanup()`        | Declared in typings, not exposed in the supplied Luau runtime |

## Build Behavior

The runtime plugin:

- inserts all built-in pipelines against the corresponding `RunService` events
- sets the scheduler’s default dependency graph to the heartbeat pipeline graph
- sets the default phase to `Phases.Update`

That last behavior explains why systems often land in heartbeat update behavior by default once the plugin is installed.
