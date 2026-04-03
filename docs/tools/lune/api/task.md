# Task API

Import:

```luau
local task = require("@lune/task")
```

## Functions

- `cancel(thread: thread) -> ()`
  Stops a currently scheduled thread from resuming.
- `defer(functionOrThread: (...any) -> () | thread, ...: any) -> thread`
  Runs work at the end of the current task queue.
- `delay(duration: number, functionOrThread: (...any) -> () | thread, ...: any) -> thread`
  Runs work after `duration` seconds.
- `spawn(functionOrThread: (...any) -> () | thread, ...: any) -> thread`
  Runs work immediately. If it yields, the caller resumes and the work continues in the background.
- `wait(duration: number?) -> number`
  Waits for at least the given duration and returns the actual time waited.

## Ordering

- immediate: `task.spawn`
- deferred: `task.defer`
- delayed: `task.delay`
