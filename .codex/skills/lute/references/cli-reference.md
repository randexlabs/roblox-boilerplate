# CLI Reference

## Top-Level Command Model

Lute exposes a CLI for running, type-checking, compiling, testing, linting, setting up editor support, and applying code transforms.

General shape:

```bash
lute <command> [options] [arguments...]
```

If no explicit command is given, `run` is the default behavior.

### Built-In Commands

| Command     | Purpose                                             |
| ----------- | --------------------------------------------------- |
| `check`     | Type check Luau files.                              |
| `compile`   | Compile a Luau script into a standalone executable. |
| `lint`      | Lint Luau code with built-in or custom rules.       |
| `run`       | Run a Luau script.                                  |
| `setup`     | Generate editor/type-definition support.            |
| `test`      | Discover and run tests.                             |
| `transform` | Apply source-to-source transforms.                  |

### Global Options

| Option         | Meaning                |
| -------------- | ---------------------- |
| `-h`, `--help` | Display help.          |
| `--version`    | Show the Lute version. |

## `run`

Run a Luau script.

```bash
lute run <script.luau> [args...]
```

Equivalent shorthand:

```bash
lute <script.luau> [args...]
```

### Profiling Mode

Lute includes a sampling profiler that emits JSON traces viewable in `ui.perfetto.dev`.

Important limitation preserved from the docs:

- the profiler currently only works with single-threaded code

Profiling form:

```bash
lute --profile [--profile-output somefile] [--frequency <Hz>] <script.luau> [args...]
```

#### Options

- `-h, --help`: display usage
- `--profile`: enable profiling
- `--profile-output <filename>`: choose the output trace filename
- `--frequency <number in Hz>`: choose sampling frequency

Defaults preserved from the docs:

- frequency defaults to `10000Hz`
- output filename defaults to `<datetime>_<filename>.json`

## `check`

Type-check one or more files:

```bash
lute check <file1.luau> [file2.luau...]
```

Option:

- `-h, --help`

## `compile`

Compile a Luau entry script plus its dependencies into a standalone executable:

```bash
lute compile <entry.luau> [options]
```

### Options

- `--output <path>`: output executable name; defaults to the entry basename, with `.exe` on Windows
- `--bundle-stats`: print bytecode bundle size and compression statistics
- `--show-require-graph`: print the included dependency graph
- `-h, --help`: display usage

### Examples

Compile to the default executable name derived from the entry file:

```bash
lute compile foo.luau
```

Compile to a custom executable name:

```bash
lute compile foo.luau --output main
```

## `setup`

Generate type-definition files for editor and language-server integration:

```bash
lute setup
```

### Option

- `--with-luaurc`: define aliases to the generated definition files in the current working directory's `luaurc`

This command is central to the getting-started docs because it improves autocomplete and type-checking in editors using `luau-lsp`.

## `test`

Discover and run `.test.luau` and `.spec.luau` files.

The docs note that discovery defaults to the current working tree and commonly targets `tests/`.

```bash
lute test [OPTIONS] [PATHS...]
```

### Options

- `-h, --help`: show help
- `--list`: list discovered tests without running them
- `-s, --suite SUITE`: run only the named suite
- `-c, --case CASE`: run only matching case names

### Arguments

- directories or files to search, defaulting to `./`

### Examples

Run all tests:

```bash
lute test
```

List all discovered tests:

```bash
lute test --list
```

Run all tests in one suite:

```bash
lute test -s MyTestSuite
```

Run a specific case inside a suite:

```bash
lute test --suite MyTestSuite --case mytest
```

Run any case whose name matches a string:

```bash
lute test --case "some case"
```

List tests discovered in another directory:

```bash
lute test --list my/other/testdir
```

## `transform`

Apply a specified transformation script to one or more Luau files:

```bash
lute transform <transformer script> [options...] <files...>
```

Practical note preserved from the docs:

- a transformer can define custom migration options, and those are parsed as additional command-line arguments

Example shape:

```bash
lute transform transformer.luau --custom-arg=value transformee.luau
```

### Options

- `--dry-run`: compute the transformation without overwriting or deleting files
- `--output <path>`: choose an output file for a transformed file; only valid when transforming a single file

Default behavior:

- if `--output` is not supplied, Lute overwrites the target file in place

## Relationship Between CLI Commands and Guides

Some commands have richer conceptual guidance elsewhere in the corpus:

- `test`: see the tutorial material for suites, assertions, lifecycle hooks, and failure analysis
- `lint`: see the lint reference for config structure and built-in rule behavior
- `transform`: see the transform guide for CST concepts and implementation patterns
