# Runtime Definitions, Annotations, and Caveats

## What These Definitions Represent

The local `definitions/` files describe the low-level runtime-facing API surface, mostly under `@lute/...`.

Important practical distinction:

- the definitions are the closest thing to a contract for runtime functions and exported types
- many examples in the repo use the higher-level `@std/...` wrappers instead
- the `@std` wrappers often rename operations to be more ergonomic or path-aware

Do not answer `@std/fs` questions by blindly copying names from `definitions/fs.luau`. The low-level `@lute/fs` API and the higher-level `@std/fs` API are related, but not identical.

## How To Read The Annotations

The definitions use several patterns that carry practical meaning.

### Optional Parameters

`param: Type?` means the parameter is optional and may be omitted or `nil`.

Examples:

- `fs.open(path, mode?)`
- `process.run(args, options?)`
- `task.wait(dur?)`

Practical implication:

- defaults often exist, but only when explicitly documented in the adjacent comment
- do not invent defaults that are not stated in the definition comments

### Nullable Return-Adjacent Fields

Some result fields can be absent:

- `ProcessResult.signal: string?`
- many network callback fields are optional
- `ServerResponse` fields such as `status`, `body`, and `headers` are optional inside the table form

Practical implication:

- code consuming these fields should not assume presence unless the API contract guarantees it

### Readonly Fields

Some exported record fields are marked `read`, which means callers should treat them as immutable output data rather than mutable configuration.

Examples:

- `crypto.SecretBox.ciphertext`
- `crypto.SecretBox.nonce`
- `crypto.SecretBox.key`

Practical implication:

- do not write docs or examples that mutate these values in place as if they were ordinary mutable tables

### `never`

`process.exit(exitcode: number): never` indicates control flow does not return.

Practical implication:

- any code after `process.exit(...)` is unreachable by contract
- do not describe it as “returns after exiting”

### Generic Variadics

`task.spawn<T..., U...>(routine, ...: T...): thread` and similar signatures preserve arbitrary argument lists.

Practical implication:

- these APIs forward arbitrary arguments into the scheduled routine
- examples that pass values through `task.spawn` and `task.delay` are relying on this

### Metatable-Backed Opaque Types

`time.Duration` and `time.Instant` are exported as locked, metatable-backed values rather than plain tables.

Practical implication:

- they support documented arithmetic/comparison operations
- callers should treat them as opaque values, not ad-hoc tables to inspect or mutate

## Annotation And Comment Conventions

The repo also includes an example that demonstrates how documentation is meant to be extracted from code comments.

Observed conventions:

- `---` comments directly above function/property declarations are intended to be captured as docs
- multiple consecutive `---` comments are preserved
- some block comments with long-bracket syntax can also be captured
- ordinary `--` comments and unrelated comments above non-exported code are not treated the same way

Practical implication:

- when documenting functions from source, prioritize the structured doc comments nearest the declaration
- do not treat every nearby comment as part of the API contract

## Cross-Cutting Caveat: `@lute` vs `@std`

This is the most important caveat extracted from the codebase.

### `@lute`

The `definitions/` layer mainly describes lower-level primitives:

- string-based file paths
- raw file handles
- direct process/system functions
- raw watch callbacks
- runtime-native networking and task primitives

### `@std`

The `@std` layer often wraps those primitives with:

- path-aware `Pathlike` handling
- convenience helpers
- recursive helpers
- iterator patterns
- names that read more like application utilities

Examples of naming differences:

| Low-level/runtime-oriented    | Higher-level/std-oriented                     |
| ----------------------------- | --------------------------------------------- |
| `fs.stat`                     | `fs.metadata`                                 |
| `fs.mkdir`                    | `fs.createDirectory`                          |
| `fs.rmdir`                    | `fs.removeDirectory`                          |
| `fs.listdir`                  | `fs.listDirectory`                            |
| manual `open`/`write`/`close` | `fs.writeStringToFile`                        |
| callback-driven `fs.watch`    | iterator-style `fs.watch(...):next()` wrapper |

What to avoid:

- do not answer `@std/fs` questions with `@lute/fs` names unless you explicitly say you are dropping down to the runtime API
- do not assume examples using `@std` prove the low-level definitions have the same surface area

## Filesystem Definitions (`@lute/fs`)

### Core Types

`FileHandle`:

- contains `fd: number`
- contains `err: number`

Practical caveat:

- this shape suggests runtime-level file descriptors and error-state exposure
- even though the definition comment says `fs.open` returns a file handle, example code in `@std/fs` treats the happy path as a valid handle abstraction and avoids poking into `fd`/`err` directly
- avoid encouraging users to depend on internal handle fields unless they are solving a runtime-adjacent problem

`FileMetadata` exposes:

- `type`
- `permissions.readonly`
- `size`
- `created`
- `accessed`
- `modified`

Important detail:

- timestamps are typed as `time.Duration`, not raw numbers
- do not describe them as Unix timestamps unless verified elsewhere

### Open Modes

The allowed modes are:

- `"r"`
- `"w"`
- `"x"`
- `"a"`
- `"r+"`
- `"w+"`
- `"x+"`
- `"a+"`

Practical caveats from the comments:

- `"w"` and `"w+"` truncate existing files
- `"x"` and `"x+"` fail if the target already exists
- `"a"` and `"a+"` append at the end
- `"r"` and `"r+"` fail if the file does not exist

What to avoid:

- do not recommend `"w"`/`"w+"` when preserving existing contents matters
- do not recommend `"x"` for update-in-place workflows

### Direct Operations

The low-level API exposes:

- `open`
- `read`
- `write`
- `close`
- `remove`
- `stat`
- `type`
- `mkdir`
- `link`
- `symlink`
- `watch`
- `exists`
- `copy`
- `move`
- `listdir`
- `rmdir`

Notable caveats:

- `mkdir` does not expose a parents/recursive option at this level
- `rmdir` is single-directory removal at this level
- `move` may fall back to copy-then-remove across filesystems
- `watch` is callback-based at the runtime layer

What to avoid:

- do not imply `mkdir` behaves like `mkdir -p`
- do not imply `rmdir` recursively removes children
- do not promise atomic cross-filesystem moves

### Watch Events

`WatchEvent` only exposes:

- `change: boolean`
- `rename: boolean`

Practical implication:

- the event payload is intentionally coarse
- do not over-document it as a rich event model with guaranteed filenames, operation kinds, or content diffs

## `@std/fs` Caveats Confirmed By Source

The higher-level stdlib wrapper adds several important behaviors:

- `Pathlike` support instead of raw strings only
- `createDirectory(..., { makeParents = true })`
- `removeDirectory(..., { recursive = true })`
- `readFileToString`
- `writeStringToFile`
- `walk(path, { recursive = true })`
- `watch(path)` that returns a watcher with `:next()` and `:close()`

Important caveats from std source and examples:

- the watcher is polled with `:next()` rather than iterated with `for`
- `walk` returns an iterator function
- recursive directory creation/removal is std-level behavior layered on top of the lower-level runtime

What to avoid:

- do not write examples that assume `watch` is a blocking iterator
- do not assume `walk` recursively descends unless `recursive = true`

## Process Definitions (`@lute/process`)

### Environment and Arguments

- `process.args` is an array of strings for the current script
- `process.env` is a mutable string-to-string table for environment variables

Practical caveat:

- examples mutate `process.env`, so it is not just a read-only snapshot
- do not present it as immutable process metadata

### `run` vs `system`

`process.run(args, options?)`:

- runs `args[1]` as the program
- remaining entries are the argument list

`process.system(command, options?)`:

- runs through a shell
- optionally accepts a specific shell executable

What to avoid:

- do not confuse shell command strings with argv-style execution
- prefer `run` when argument boundaries matter
- use `system` only when shell semantics are actually intended

### Stdio Handling

`stdio` accepts:

- `"default"`
- `"inherit"`
- `"none"`

Practical caveat:

- `"default"` captures stdout/stderr into the result
- if you set `"inherit"`, downstream code should not rely on captured output in the same way

### Signals

The definitions explicitly warn:

- only `SIGINT` and `SIGTERM` are guaranteed cross-platform
- other signals may be unsupported and degrade to no-op behavior

What to avoid:

- do not document Unix-heavy signals as portable guarantees
- be explicit when a signal-based solution is platform-sensitive

### Default-Behavior Suppression

`process.onSignal` suppresses the default OS behavior once you register the callback.

Practical implication:

- trapping `SIGINT` means Ctrl+C no longer automatically terminates the process

What to avoid:

- do not recommend signal hooks without explaining that they replace default termination behavior

## Task Definitions (`@lute/task`)

The task API exposes scheduling primitives rather than a promise/future abstraction.

Available operations:

- `spawn`
- `defer`
- `resume`
- `deferSelf`
- `wait`
- `delay`

Important caveats:

- `wait` accepts either a number or `time.Duration`, or nothing
- `wait` returns the actual time waited
- `resume` works on a thread and runs it until yield/completion

Examples show:

- `task.delay` accepts either a coroutine thread or a function
- arbitrary arguments are forwarded into the scheduled routine

What to avoid:

- do not describe these as parallel threads with OS isolation
- do not assume `resume` returns the coroutine result; the definition says it returns the thread

## Time Definitions (`@lute/time`)

### `Instant` vs `Duration`

The code clearly distinguishes:

- `Instant`: a point in time
- `Duration`: an amount of time

Supported operations:

- `Instant - Instant -> Duration`
- `Duration` arithmetic with `+`, `-`, `*`, `/`
- duration and instant comparisons

Convenience constructors exist for:

- nanoseconds
- microseconds
- milliseconds
- seconds
- minutes
- hours
- days
- weeks

Practical caveat:

- `time.since(instant)` returns a `number`
- `instant:elapsed()` also returns a `number`
- metadata timestamps in fs are typed as `Duration`

What to avoid:

- do not flatten all time values into the same conceptual bucket
- keep “clock point” and “elapsed amount” distinct

## Networking Definitions

### Client Side

`@lute/net/client` exposes:

- `request(url, metadata?)`
- `websocket(url, options?)`

The HTTP response shape includes:

- `body`
- `headers`
- `status`
- `ok`

Practical caveat:

- `ok` exists explicitly, so code does not need to infer success solely from `status`

WebSocket callbacks are optional:

- `onopen`
- `onmessage`
- `onclose`
- `onerror`

What to avoid:

- do not assume text-only messages; callbacks may receive `string | buffer`

### Server Side

`ServerResponse` can be either:

- a plain string body
- or a table with optional `status`, `body`, and `headers`

Practical implication:

- simple handlers can return a string directly
- richer handlers can return a response object

`Handler` returns `ServerResponse?`, so `nil` is part of the type contract.

What to avoid:

- do not claim every handler must build a full response table

## Luau Introspection Definitions

The large `definitions/luau.luau` file exposes tooling-oriented Luau internals rather than everyday application helpers.

Major surfaces present in the definitions:

- source spans and trivia
- CST token/node types for expressions, statements, types, and type packs
- `parse(source)`
- `parseExpr(source)`
- `compile(source)`
- `load(bytecode, chunkname, env?)`
- `resolveModule(path, fromchunkname)`
- `typeofModule(modulepath)`

Practical implications:

- this layer is aimed at analyzers, transforms, tooling, and code intelligence
- CST nodes are strongly tagged and structurally rich
- resolved type information is available, but the return from `typeofModule` is nullable

Useful caveats extracted from the definitions:

- `typeofModule(...)` returns `TypePack?`, so failure or unavailability is part of the contract
- `load(...)` accepts an optional environment override table, which means loaded bytecode does not have to run in the default global environment
- CST types are intentionally granular; do not flatten everything into “AST nodes” if the distinction between expression/stat/type/typepack matters

What to avoid:

- do not assume `typeofModule` always succeeds
- do not present CST nodes as casually mutable syntax objects unless verified elsewhere
- do not answer transform or parser questions using only the high-level guide if the exact node/tag structure matters

## Crypto Definitions

### Hashing

`crypto.digest(hash, message)` accepts:

- a hash algorithm token such as `crypto.hash.sha256`
- a `string` or `buffer` message

What to avoid:

- do not treat algorithm names as arbitrary strings; the type design strongly suggests using the exported algorithm tokens

### Secretbox

`secretbox.seal(message, key?)` returns a `SecretBox` containing:

- ciphertext
- nonce
- key

Practical caveat:

- if `key` is omitted, a fresh key may be generated
- that is convenient for demos but dangerous if callers do not persist the returned key alongside the ciphertext

What to avoid:

- do not document “omit the key” as a good default for workflows that need later decryption unless you also preserve the returned key

### Password Hashing

The password API is explicitly for slow, memory-hard password storage.

What to avoid:

- do not reuse `password.hash` as a general-purpose content digest
- use `digest` for normal hashing and `password.hash` for credential storage

## VM Definitions

`vm.create(path)` creates a new Luau VM from the module at `path` and returns its exported table.

Practical caveat:

- the return type is broad: `{ [any]: any }`
- this is intentionally loose and should not be treated as a strongly typed module contract

What to avoid:

- do not present `vm.create` as preserving precise static type information

## Safe Documentation Habits For Future Answers

When answering from these definitions:

1. Say whether you are describing `@lute` or `@std`.
2. Preserve documented defaults and failure behavior.
3. Treat optional fields and nullable branches as real API surface, not noise.
4. Avoid inventing stronger guarantees than the type/comments provide.
5. Use examples to explain the intended happy path, but let definitions constrain the guarantees.
