# `definitions/time.luau`

## Purpose

This definition file describes the low-level time API exposed under `@lute/time`.

Use this file when the question is about:

- time instants
- durations
- duration arithmetic
- precision and conversion helpers

## Core Concepts

The file distinguishes two important opaque value types:

- `Instant`: a point in time
- `Duration`: an amount of time

Do not flatten these into one conceptual bucket.

## Top-Level Functions

### `time.now() -> Instant`

Returns the current time as an `Instant`.

### `time.since(instant) -> number`

Returns the number of seconds elapsed since an instant.

Important caveat:

- this returns a `number`, not a `Duration`

## Duration Constructors

Available constructors:

- `create(seconds, subsecnanos)`
- `nanoseconds(...)`
- `microseconds(...)`
- `milliseconds(...)`
- `seconds(...)`
- `minutes(...)`
- `hours(...)`
- `days(...)`
- `weeks(...)`

Practical meaning:

- the API is designed to let callers express durations in natural units instead of manual scalar conversion

## Duration Methods

Conversions:

- `toNanoseconds`
- `toMicroseconds`
- `toMilliseconds`
- `toSeconds`
- `toMinutes`
- `toHours`
- `toDays`
- `toWeeks`

Sub-second component helpers:

- `subsecnanos`
- `subsecmicros`
- `subsecmillis`

## Instant Methods

### `instant:elapsed() -> number`

Returns elapsed seconds from that instant.

Important caveat:

- like `time.since`, this is scalar-seconds output rather than a `Duration`

## Operators

`Duration` supports:

- `+`
- `-`
- `* number`
- `/ number`
- equality/comparison

`Instant` supports:

- subtraction against another `Instant` to produce a `Duration`
- equality/comparison

## Opaque-Type Caveat

Both `Instant` and `Duration` are locked metatable-backed values.

Practical meaning:

- treat them as opaque structured values
- use constructors, operators, and methods instead of trying to inspect or mutate their internals

## Example-Backed Usage

The local examples use:

- `task.wait(time.duration.seconds(1))`
- `time.now()`
- arithmetic between time values

The filesystem-related examples also use metadata timestamps as structured values.

## What To Avoid

- do not describe all time results as the same type
- do not present `Instant` as if it were just a number
- do not assume metadata timestamps are plain Unix timestamps
