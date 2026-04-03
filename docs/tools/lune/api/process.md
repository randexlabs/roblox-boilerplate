# Process API

Import:

```luau
local process = require("@lune/process")
```

## Globals

- `process.args: {string}`

## Functions

- `create(program: string, params: {string}?, options: CreateOptions?) -> ChildProcess`
  Spawns a child process in the background and returns readers and writers for it.
- `exec(program: string, params: {string}?, options: ExecOptions?) -> ExecResult`
  Executes a child process, waits for exit, and returns status plus captured output.
- `exit(code: number?) -> never`
  Exits the current process.

## Types

### `ExecStdioKind`

- `"default"`
- `"inherit"`
- `"forward"`
- `"none"`

### `ExecStdioOptions`

- `stdin: string | buffer?`
- `stdout: ExecStdioKind?`
- `stderr: ExecStdioKind?`

### `ExecOptions`

- `cwd: string?`
- `env: {[string]: string}?`
- `shell: boolean | string?`
- `stdio: ExecStdioOptions?`

### `CreateOptions`

- `cwd: string?`
- `env: {[string]: string}?`
- `shell: boolean | string?`

### `ChildProcess`

- `stdin: ChildProcessWriter`
- `stdout: ChildProcessReader`
- `stderr: ChildProcessReader`
- `kill: () -> ()`
- `status: () -> number`

### `ExecResult`

- `ok: boolean`
- `code: number`
- `stdout: string`
- `stderr: string`

### `ChildProcessReader`

- `read(chunkSize: number?) -> string?`
- `readToEnd() -> string`

### `ChildProcessWriter`

- `write(data: string | buffer) -> ()`
- `close() -> ()`
