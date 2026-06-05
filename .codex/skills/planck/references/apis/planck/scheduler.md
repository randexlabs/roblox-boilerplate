# `planck` Scheduler

## Constructor

| API                      | Purpose                                                                           | Notes                                |
| ------------------------ | --------------------------------------------------------------------------------- | ------------------------------------ |
| `Scheduler.new(...args)` | Create a scheduler and capture the arguments passed to all systems and conditions | There is no separate `start()` step. |

Whatever arguments you pass here become the arguments passed into all systems and conditions.

## System Registration And Editing

| API                                      | Purpose                      | Notes                                                |
| ---------------------------------------- | ---------------------------- | ---------------------------------------------------- |
| `scheduler:addSystem(system, phase?)`    | Register one system          | Explicit phase overrides implicit/default placement. |
| `scheduler:addSystems(systems, phase?)`  | Register many systems        | Useful in startup/bootstrap modules.                 |
| `scheduler:editSystem(system, newPhase)` | Move a system to a new phase | Triggers the runtime `SystemEdited` hook.            |
| `scheduler:removeSystem(system)`         | Unschedule a system          | Runs cleanup first if the system provided one.       |
| `scheduler:replaceSystem(old, new)`      | Swap one system for another  | Useful for hot reload or live replacement.           |

## Execution

| API                       | Purpose                                       | Notes                                                     |
| ------------------------- | --------------------------------------------- | --------------------------------------------------------- |
| `scheduler:run(phase)`    | Run all systems in one phase                  | Ordered by phase then by system insertion.                |
| `scheduler:run(pipeline)` | Run all systems in all phases of one pipeline | Uses pipeline phase order.                                |
| `scheduler:run(system)`   | Run one specific system                       | Still uses scheduler args.                                |
| `scheduler:runAll()`      | Run the full schedule                         | Default group first, then event groups in creation order. |

## Time Access

| API                        | Purpose                                       | Notes                                                |
| -------------------------- | --------------------------------------------- | ---------------------------------------------------- |
| `scheduler:getDeltaTime()` | Return time since the current system last ran | Must be called inside a registered system execution. |

This is intended for frame-relative systems, not general-purpose timing code.

## Cleanup

| API                   | Purpose                                                                     | Notes                                            |
| --------------------- | --------------------------------------------------------------------------- | ------------------------------------------------ |
| `scheduler:cleanup()` | Disconnect events, invoke plugin cleanup, and tear down scheduler resources | Intended for schedulers that will not be reused. |

The docs explicitly say throwaway schedulers plus debugger-style plugins should be used carefully.

## Event Groups

Planck groups inserted phases and pipelines by event.

Group behavior:

- inserts without an event join the default group
- each event gets its own group
- groups are internally ordered, but not globally dependency-sorted together
- `runAll()` runs the default group first, then event groups in the order those groups were created
