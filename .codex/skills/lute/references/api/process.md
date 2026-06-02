# `definitions/process.luau`

## Purpose

This definition file describes the low-level process API exposed under `@lute/process`.

Use this file when the question is about:

- current process args or environment
- child process execution
- shell execution
- stdio handling
- signal handling
- PID, cwd, home dir, or executable path

## Process-Level State

### `process.args`

An array of strings representing the current script arguments.

Practical meaning:

- this is the raw argv-style view exposed to scripts

### `process.env`

A string-to-string table of environment variables.

Important example-backed caveat:

- local examples mutate this table directly

What to avoid:

- do not describe it as immutable snapshot data

## Options Types

### `ProcessRunOptions`

Optional fields:

- `cwd`
- `stdio`
- `env`

### `ProcessSystemOptions`

Optional fields:

- `system`
- `cwd`
- `stdio`
- `env`

## Result Type

### `ProcessResult`

Fields:

- `stdout`
- `stderr`
- `ok`
- `exitcode`
- `signal?`

Important caveat:

- `signal` is optional

## Signals

Supported signal literals include:

- `SIGINT`
- `SIGTERM`
- `SIGHUP`
- `SIGQUIT`
- `SIGUSR1`
- `SIGUSR2`
- `SIGWINCH`
- `SIGPIPE`
- `SIGBREAK`
- `SIGALRM`

Cross-platform guarantee from the definition comments:

- only `SIGINT` and `SIGTERM` are guaranteed everywhere
- unsupported signals may behave as no-ops

What to avoid:

- do not document Unix-heavy signals as portable guarantees

## Functions

### `process.homedir() -> string`

Returns the user's home directory.

### `process.cwd() -> string`

Returns the current working directory.

### `process.run(args, options?) -> ProcessResult`

Runs `args[1]` as the program and the rest as argv entries.

Practical meaning:

- use this when exact argument boundaries matter

### `process.system(command, options?) -> ProcessResult`

Runs a command string through a shell.

Practical meaning:

- use this only when shell features are intended

What to avoid:

- do not confuse shell-command semantics with argv execution

### `process.exit(exitcode) -> never`

Exits the process and never returns.

### `process.execPath() -> string`

Returns the path to the current `lute` executable.

### `process.pid() -> number`

Returns the current process ID.

### `process.onSignal(signal, callback) -> SignalHandle`

Registers a signal handler.

Important caveat from the definition comments:

- registering a handler suppresses the default OS behavior

Practical consequence:

- trapping `SIGINT` means Ctrl+C no longer automatically terminates the process

## `@std/process` Wrapper

The stdlib wrapper:

- returns `Path` values for `homedir`, `cwd`, and `execPath`
- re-exports args, env, and process methods
- keeps `run`/`system` semantics essentially the same

## Example-Backed Usage

The local examples show:

- direct argv-style execution with `run`
- shell execution with `system`
- env overrides for child processes
- cwd overrides for child processes
- explicit shell selection
- direct mutation of `process.env`

## What To Avoid

- do not recommend `system` when users really need argv-safe process launching
- do not forget that `"default"` stdio captures output, while other modes change that expectation
- do not install signal handlers without explaining the change to default termination behavior
