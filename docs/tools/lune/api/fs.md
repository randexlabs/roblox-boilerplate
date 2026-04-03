# FS API

Import:

```luau
local fs = require("@lune/fs")
```

## Functions

- `readFile(path: string) -> string`
  Reads a file. Errors if the path is missing, unreadable, or another I/O failure occurs.
- `readDir(path: string) -> {string}`
  Reads entries in a directory. Errors if the path is missing, unreadable, or another I/O failure occurs.
- `writeFile(path: string, contents: string) -> ()`
  Writes a file. Errors if the parent directory is missing, unwritable, or another I/O failure occurs.
- `writeDir(path: string) -> ()`
  Creates a directory and missing parents. Errors if the path already exists or cannot be created.
- `removeFile(path: string) -> ()`
  Removes a file.
- `removeDir(path: string) -> ()`
  Removes a directory and its contents.
- `metadata(path: string) -> Metadata`
  Reads metadata for a path.
- `isFile(path: string) -> boolean`
- `isDir(path: string) -> boolean`
- `move(from: string, to: string, overwriteOrOptions: boolean | WriteOptions?) -> ()`
  Moves a file or directory. Can overwrite when allowed by options.
- `copy(from: string, to: string, overwriteOrOptions: boolean | WriteOptions?) -> ()`
  Copies a file or directory recursively. Can overwrite when allowed by options.

## Types

### `MetadataPermissions`

- `readOnly: boolean`

### `Metadata`

- `kind: "file" | "dir" | "symlink"`
- `exists: boolean`
- `createdAt: DateTime`
- `modifiedAt: DateTime`
- `accessedAt: DateTime`
- `permissions: MetadataPermissions`

### `WriteOptions`

- `overwrite: boolean?`
