# CLI API

## Basic Command

```sh
blink file-name
```

Resolution behavior:

- the CLI checks the supplied path as-is
- then tries `.txt`
- then tries `.blink`

## Watch Command

```sh
blink file-name --watch
```

Behavior:

- recursively gathers imports
- prints watched entry plus import count when the set changes
- recompiles whenever an entry or import timestamp changes
- sleeps for one second between watch scans

## Flags

## `-h`, `--help`

Print help information.

## `-v`, `--version`

Print version information after the banner.

## `-w`, `--watch`

Watch the target config and imported files for changes.

## `-q`, `--quiet`

Silence program output.

## `-c`, `--compact`

Compacts error output, while still printing the full message afterward.

## `-y`, `--yes`

Accept output-directory creation prompts automatically.

## `--ast`

Hidden debug flag that prints parsed options and declarations instead of generating files.

## `-S`, `--stats`

Hidden debug flag that prints parse and generation timing.

## Compile-Time Behavior

The CLI compile path:

1. resolves the definition file path
2. reads and parses the source
3. asserts `ClientOutput` and `ServerOutput`
4. creates missing directories after prompt or `--yes`
5. generates client and server Luau
6. optionally generates shared Luau and TypeScript files

Debug timing output includes:

- parse time
- server generation time
- client generation time
- file generation total
- end-to-end total
