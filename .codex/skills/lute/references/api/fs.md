# `definitions/fs.luau`

## Purpose

This definition file describes the low-level runtime filesystem API exposed under `@lute/fs`.

Use this file when the question is about:

- raw file handles
- open modes
- direct file or directory operations
- low-level watcher semantics
- what the stdlib `@std/fs` wraps or changes

## Contract Level

This is a low-level API. In normal app code, the repo examples prefer `@std/fs`, which adds:

- `Pathlike` handling
- `metadata` instead of `stat`
- `createDirectory` instead of `mkdir`
- `removeDirectory` instead of `rmdir`
- `listDirectory` instead of `listdir`
- convenience helpers such as `readFileToString`, `writeStringToFile`, `walk`, and a polled watcher

Do not answer `@std/fs` questions by copying names directly from this file without calling out the layer change.

## Core Types

### `FileHandle`

```luau
{
    fd: number,
    err: number,
}
```

Practical meaning:

- this is a runtime-oriented handle, not just an opaque token
- the presence of `fd` and `err` suggests OS-adjacent internals

What to avoid:

- do not encourage users to depend on `fd` or `err` unless they are doing runtime-adjacent work
- day-to-day code should treat the handle as opaque

### `FileType`

Possible values:

- `"file"`
- `"dir"`
- `"link"`
- `"fifo"`
- `"socket"`
- `"char"`
- `"block"`
- `"unknown"`

Practical meaning:

- directory operations should check for `"dir"` explicitly when behavior differs
- the API is not limited to regular files and directories

### `FileMetadata`

Fields:

- `type`
- `permissions.readonly`
- `size`
- `created`
- `accessed`
- `modified`

Important caveat:

- the timestamps are `time.Duration` values, not documented here as raw Unix timestamps

What to avoid:

- do not document these timestamp fields as plain integer epoch values unless confirmed elsewhere

### `DirectoryEntry`

Fields:

- `name`
- `type`

This is the element type returned by `listdir`.

### `WatchHandle`

The runtime watcher handle only exposes:

- `:close()`

### `WatchEvent`

Fields:

- `change: boolean`
- `rename: boolean`

Practical meaning:

- the event model is intentionally coarse

What to avoid:

- do not over-promise rich event detail such as guaranteed full paths, change kinds, or content diffs

## Open Modes

Allowed values:

- `"r"`
- `"w"`
- `"x"`
- `"a"`
- `"r+"`
- `"w+"`
- `"x+"`
- `"a+"`

Important semantics captured in the definition comments:

- `"r"` and `"r+"` fail if the file does not exist
- `"w"` and `"w+"` create if missing and truncate if present
- `"x"` and `"x+"` fail if the file already exists
- `"a"` and `"a+"` append at the end

What to avoid:

- do not recommend `"w"` or `"w+"` if preserving contents matters
- do not recommend `"x"` or `"x+"` for “update existing file” workflows

## Functions

### `fs.open(path, mode?) -> FileHandle`

Opens a path using the selected mode. Defaults to `"r"`.

Practical meaning:

- reads are not the default fallback for write workflows; you must opt into a write-capable mode

### `fs.read(handle) -> string`

Reads the entire contents of the handle.

Practical meaning:

- this is full-handle read behavior, not a chunked streaming API

### `fs.write(handle, contents) -> ()`

Writes a string to the handle.

### `fs.close(handle) -> ()`

Closes the handle and flushes pending writes.

What to avoid:

- do not omit `close` in write-heavy examples where flush timing matters

### `fs.remove(path) -> ()`

Removes a file.

### `fs.stat(path) -> FileMetadata`

Returns metadata for a file or directory.

### `fs.type(path) -> FileType`

Returns just the entry type.

### `fs.mkdir(path) -> ()`

Creates a directory.

Important caveat:

- there is no recursive/make-parents option at this layer

What to avoid:

- do not imply `mkdir -p` behavior

### `fs.link(src, dest) -> ()`

Creates a hard link.

### `fs.symlink(src, dest) -> ()`

Creates a symbolic link.

### `fs.watch(path, callback) -> WatchHandle`

Watches a path and invokes a callback with `filename` and `WatchEvent`.

Practical meaning:

- the low-level API is callback-driven

What to avoid:

- do not describe this as the same interface used by `@std/fs.watch`

### `fs.exists(path) -> boolean`

Returns whether something exists at the path.

### `fs.copy(src, dest) -> ()`

Copies a file.

### `fs.move(src, dest) -> ()`

Moves a file or directory.

Important caveat from the definition comment:

- it may fall back to copy-then-remove when source and destination are on different filesystems

What to avoid:

- do not promise atomic rename semantics across filesystems

### `fs.listdir(path) -> { DirectoryEntry }`

Lists the immediate children of a directory.

### `fs.rmdir(path) -> ()`

Removes a directory.

Important caveat:

- no recursive deletion option exists at this layer

What to avoid:

- do not present it as recursive removal

## Higher-Level Usage in `@std/fs`

The stdlib wrapper adds the intended day-to-day shape used by the examples:

- `createDirectory(path, { makeParents = true })`
- `removeDirectory(path, { recursive = true })`
- `metadata(path)`
- `listDirectory(path)`
- `writeStringToFile(path, contents)`
- `readFileToString(path)`
- `walk(path, { recursive = true })`
- `watch(path)` returning an object with `:next()` and `:close()`

Important source-backed caveats:

- std `watch` is polled, not iterated in a `for` loop
- std `walk` only recurses when `recursive = true`

## Example-Backed Usage Patterns

The local examples show these common patterns:

- open/write/close for explicit low-level file writing
- `createDirectory(..., { makeParents = true })` plus `removeDirectory(...)`
- `listDirectory(...)` for immediate-child listing
- `metadata(...)` to inspect timestamps
- `walk(...)` via an iterator function
- polling a watcher with `:next()` and `task.wait(...)`
