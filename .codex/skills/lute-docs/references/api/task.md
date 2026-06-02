# `definitions/task.luau`

## Purpose

This definition file describes the low-level cooperative task scheduler API exposed under `@lute/task`.

Use this file when the question is about:

- scheduling routines
- delaying or deferring work
- manual coroutine resumption
- yielding and waiting

## Functions

### `task.spawn(routine, ...) -> thread`

Schedules a routine to run on the next resumption cycle.

Practical meaning:

- this is immediate scheduling, not synchronous execution
- arbitrary arguments are forwarded through

### `task.defer(routine, ...) -> thread`

Schedules a routine to run after the current thread yields.

Practical meaning:

- this is explicitly later-than-spawn scheduling

### `task.resume(thread) -> thread`

Resumes a thread until it yields or completes.

Important caveat:

- the documented return is the thread, not the coroutine's yielded/returned value

What to avoid:

- do not document it as returning the coroutine result tuple

### `task.deferSelf()`

Yields the current thread and reschedules it for the next cycle.

### `task.wait(dur?) -> number`

Yields the current thread:

- for a number of seconds
- for a `time.Duration`
- or until the next cycle if omitted

Important caveat:

- it returns the actual time waited

### `task.delay(dur, routine, ...) -> thread`

Schedules work after a delay.

The low-level definition accepts:

- `number`
- `time.Duration`

and either:

- a thread
- or a function

## `@std/task` Wrapper

The stdlib wrapper re-exports:

- `spawn`
- `defer`
- `delay`
- `wait`
- `cancel`

Important caveat from source:

- the std wrapper types `delay` and `wait` in seconds only, while the low-level `@lute/task` definition also accepts `time.Duration`

Practical consequence:

- if the user wants `time.Duration` explicitly, keep the layer distinction visible

## Example-Backed Usage

The local examples demonstrate:

- waiting with numeric seconds
- waiting with `time.duration.seconds(...)` through `@lute/task`
- delaying both coroutine threads and plain functions
- resuming coroutines manually with forwarded arguments
- using `task.wait(...)` in polling loops

## What To Avoid

- do not describe this as OS-thread parallelism
- do not forget that `wait()` may be called with no argument
- do not hide the `@std/task` vs `@lute/task` duration mismatch in answers
