# `planck` Phases And Pipelines

## `Phase`

| API                 | Purpose                         | Notes                                                     |
| ------------------- | ------------------------------- | --------------------------------------------------------- |
| `Phase.new(name?)`  | Create a phase                  | Without a name, debugging falls back to script/line info. |
| `Phase.PreStartup`  | Built-in one-time startup phase | Runs before `Startup`.                                    |
| `Phase.Startup`     | Built-in one-time startup phase | Runs once before normal schedule.                         |
| `Phase.PostStartup` | Built-in one-time startup phase | Runs after `Startup`.                                     |

Use phases to express meaningful sync points, not arbitrary micro-ordering for every system.

## `Pipeline`

| API                                    | Purpose                                         | Notes                                         |
| -------------------------------------- | ----------------------------------------------- | --------------------------------------------- |
| `Pipeline.new(name?)`                  | Create a pipeline                               | Name is mainly for debugging.                 |
| `Pipeline.Startup`                     | Built-in pipeline containing the startup phases | Core package built-in.                        |
| `pipeline:insert(phase)`               | Append a phase implicitly                       | Creates ordered relation inside the pipeline. |
| `pipeline:insertAfter(phase, after)`   | Insert phase after another phase                | Explicit dependency.                          |
| `pipeline:insertBefore(phase, before)` | Insert phase before another phase               | Explicit dependency.                          |

Pipelines group related phases that all run on the same event.

## Scheduler Insertion APIs

Implicit insert:

| API                                           | Purpose                                  |
| --------------------------------------------- | ---------------------------------------- |
| `scheduler:insert(phase)`                     | Insert a phase into the default group    |
| `scheduler:insert(pipeline)`                  | Insert a pipeline into the default group |
| `scheduler:insert(phase, instance, event)`    | Insert a phase into an event group       |
| `scheduler:insert(pipeline, instance, event)` | Insert a pipeline into an event group    |

Explicit relative insert:

| API                                               | Purpose                                 |
| ------------------------------------------------- | --------------------------------------- |
| `scheduler:insertAfter(phaseOrPipeline, after)`   | Make target run after dependency        |
| `scheduler:insertBefore(phaseOrPipeline, before)` | Make target run before dependent target |

## Ordering Rules

### For phases and pipelines

Ordering uses:

- insertion order
- dependency edges

The docs describe Kahn’s algorithm as the ordering strategy.

### For systems

Systems inside a phase are ordered only by insertion order. They do not participate in the dependency graph directly.
