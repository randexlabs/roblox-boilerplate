# Lute Reference Index

This folder reorganizes the local Lute documentation into topic-grouped files for faster lookup without discarding useful context.

## How To Use This Corpus

- Start with the file that matches the user's task instead of loading everything.
- Preserve examples, notes, warnings, troubleshooting details, and contributor-facing context when they affect the answer.
- Prefer the practical guidance here over re-deriving behavior from implementation code unless the task explicitly needs implementation confirmation.

## Reference Map

### `overview-getting-started-and-tutorials.md`

Use for:

- what Lute is
- installation
- first-run editor setup
- Hello World
- the guessing-game walkthrough
- writing tests with `@std/test`

### `cli-reference.md`

Use for:

- top-level `lute` command structure
- `run`
- `check`
- `compile`
- `setup`
- `test`
- `transform`

### `linting-and-rules.md`

Use for:

- `lute lint`
- lint config structure
- custom rule loading
- output modes
- built-in lint rules and their rationale

### `code-transforms-and-program-analysis.md`

Use for:

- writing transforms
- transform context shape
- replacement maps
- query-based CST transforms
- visitor-based CST transforms

### `runtime-and-library-model.md`

Use for:

- Lute vs Luau responsibilities
- `@std` vs `@lute`
- portability expectations
- repository component model

### `runtime-definitions-and-caveats.md`

Use for:

- low-level runtime contracts from `definitions/`
- how to read function/type annotations
- optional/defaulted parameters
- readonly vs mutable fields
- `@lute` vs `@std` naming mismatches
- cross-cutting caveats before opening a specific per-definition file
- what to avoid when answering from types alone

### `api/crypto.md`

Use for:

- `definitions/crypto.luau`
- digest vs password hashing
- secretbox behavior
- key/nonce/ciphertext caveats

### `api/fs.md`

Use for:

- `definitions/fs.luau`
- raw file handles
- open modes
- metadata
- watcher semantics
- `@std/fs` differences

### `api/io.md`

Use for:

- `definitions/io.luau`
- stdin/stdout behavior
- `@std/io.input(prompt?)`

### `api/luau.md`

Use for:

- `definitions/luau.luau`
- parse / parseExpr
- CST and type nodes
- compile / load
- resolveModule
- typeofModule

### `api/net-client.md`

Use for:

- `definitions/net/client.luau`
- HTTP requests
- client WebSockets

### `api/net.md`

Use for:

- `definitions/net/init.luau`
- top-level `@lute/net` surface map

### `api/net-server.md`

Use for:

- `definitions/net/server.luau`
- request handlers
- server response shapes
- server WebSockets

### `api/process.md`

Use for:

- `definitions/process.luau`
- args/env
- run vs system
- stdio
- signals

### `api/system.md`

Use for:

- `definitions/system.luau`
- tempdir
- OS/arch
- CPU/memory/uptime

### `api/task.md`

Use for:

- `definitions/task.luau`
- spawn/defer/resume
- delay/wait
- `@std/task` differences

### `api/time.md`

Use for:

- `definitions/time.luau`
- `Instant`
- `Duration`
- operators and conversions

### `api/vm.md`

Use for:

- `definitions/vm.luau`
- VM creation
- loose typing caveats

### `examples-and-recipes.md`

Use for:

- practical usage patterns from `examples/`
- filesystem recipes
- process/system workflows
- task/time usage
- networking examples
- testing/demo patterns
- doc-comment and type-introspection examples

### `docker-and-distribution.md`

Use for:

- Docker images
- tags and pinning strategy
- container invocation patterns
- Dockerfile usage

### `build-contributing-and-release.md`

Use for:

- build/bootstrap flow
- `luthier`
- toolchain manager setup
- manual CMake/Ninja builds
- docs regeneration
- contribution rules
- PR expectations
- release process

## Source Coverage

The reorganized material is derived from the local project documentation and adjacent contributor docs, including:

- repository overview material
- docs site guides
- CLI reference pages
- lint rule reference pages
- low-level runtime definitions
- example programs and generated example docs
- docs authoring notes
- contributing guidance
- release-process notes

The goal is not to summarize the docs down to the minimum. The goal is to preserve as much practical knowledge as possible while making future retrieval faster and more intuitive.
