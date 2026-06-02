# `definitions/system.luau`

## Purpose

This definition file describes the low-level machine/system introspection API exposed under `@lute/system`.

Use this file when the question is about:

- OS and architecture
- temporary directory lookup
- memory information
- uptime
- CPU inventory

## Types

### `CpuInfo`

Fields:

- `model`
- `speed`
- `times.sys`
- `times.idle`
- `times.irq`
- `times.nice`
- `times.user`

Practical meaning:

- this is operational introspection data, not just a core count

## Functions

### `system.threadCount() -> number`

Returns the number of logical CPU threads.

### `system.hostName() -> string`

Returns the machine hostname.

### `system.tmpdir() -> string`

Returns the system temporary directory path.

### `system.totalMemory() -> number`

Returns total system memory in bytes.

### `system.freeMemory() -> number`

Returns free or available system memory in bytes.

### `system.uptime() -> number`

Returns system uptime in seconds.

### `system.cpus() -> { CpuInfo }`

Returns per-logical-processor CPU information.

## Static Properties

- `system.os`
- `system.arch`

Practical meaning:

- these are immediate platform identifiers, useful for branching behavior

## `@std/system` Wrapper

The stdlib wrapper adds:

- `tmpdir()` returning a `Path`
- boolean platform flags: `win32`, `linux`, `macos`, `unix`

Practical consequence:

- the std wrapper is usually nicer for application code, especially when path composition or platform branching is involved

## Example-Backed Usage

The local examples use `@std/system` to:

- print combined machine diagnostics
- branch on OS booleans
- derive temp directories for filesystem workflows

## What To Avoid

- do not describe `tmpdir()` as returning a `Path` at the low-level runtime layer; that conversion happens in `@std/system`
- do not collapse `threadCount()` into physical-core count; the contract says logical CPU threads
