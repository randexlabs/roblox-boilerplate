# Build, Contributing, and Release Operations

## Build System Overview

Lute uses a conventional C++ build stack built on CMake, but the project strongly emphasizes its own Luau-based build helper, `luthier`.

### Why `luthier` Exists

The docs explain that `luthier` exists to avoid overly elaborate CMake logic for:

- dependency resolution
- code generation
- incremental build orchestration

Instead, `luthier` handles when steps should run or re-run based on local changes.

### Responsibilities Called Out in the Docs

Some `luthier` commands are thin wrappers around standard build tools:

- `configure`
- `build`

Other commands provide project-specific behavior:

- `fetch`: parse dependency information from `extern/*.tune` files and resolve it via `git`
- `generate`: perform code generation to embed CLI Luau commands and the standard library into the executable

## Bootstrapping Constraint

The important operational complication is:

- producing a full `lute` executable requires the `generate` step
- the `generate` step itself needs a working `lute` to run `luthier`

The docs explicitly note that `-DLUTE_STDLESS=ON` can be used to build without embedding the standard library and related Luau functionality when bootstrapping from scratch.

## Building From Scratch

The recommended bootstrap path is the provided shell script.

### Bootstrap Script Behavior

The docs describe a small auditable bootstrap script that:

1. builds a debug `lute0` without CLI commands implemented in Luau and without embedded standard library content
2. uses `lute0` to run `luthier`
3. performs code generation
4. builds a fresh release version of `lute`

### Install Option

The bootstrap script supports `--install`.

Documented default install target:

```text
$HOME/.lute/bin/lute
```

The docs note that the script prompts during execution for where the binary should be placed, and remind contributors to ensure the installed executable is on `PATH`.

## Incremental Builds After Bootstrap

Once a working `lute` exists, the docs recommend invoking `luthier` directly:

```bash
# with `lute` on your path...
lute tools/luthier.luau build --clean {lute | Lute.CLI | Lute.Test}

# or referring directly to a specific location...
/path/to/lute tools/luthier.luau build --clean {lute | Lute.CLI | Lute.Test}
```

Practical note preserved from the docs:

- use `run` instead of `build` if you also want to invoke the appropriate executable afterward

## Building With Toolchain Managers

The docs explicitly endorse using Roblox-adjacent toolchain managers for contributor setup.

Built-in configurations are provided for:

- Foreman
- Rokit

The expected flow is:

1. install the project toolchain with `foreman install` or `rokit install`
2. use the installed `lute` to run `luthier`
3. perform clean or incremental builds through the same `build --clean` flow shown above

## Manual CMake/Ninja Build

Manual builds are supported but treated as lower-level workflow.

The docs describe the rough sequence:

1. fetch external dependencies from `extern` manually, using the `.tune` files to determine versions
2. configure with:

```bash
cmake -G=Ninja -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DLUTE_STDLESS=ON
```

3. build either:

```bash
ninja -C build lute/cli/lute
```

or:

```bash
ninja -C build tests/lute-tests
```

4. optionally run `luthier generate`, reconfigure without `-DLUTE_STDLESS=ON`, and rebuild to obtain a fully featured executable

## Documentation Authoring and Regeneration

The docs site is generated from Markdown using VitePress.

### Local Docsite Workflow

Prerequisites:

- Node.js
- npm

Workflow:

1. `cd docs`
2. `npm install`
3. `npm run dev`

The terminal output will report the local `localhost` port.

### Important Caveat

The docs explicitly warn that `npm run dev` expects `lute` on `PATH`.

If it is not available on `PATH`, the documented fallback is to run the doc generation step explicitly and then start VitePress manually.

### Regenerating Reference Pages

From the docs folder:

```bash
npm run gen
```

This regenerates reference content in the docs areas corresponding to:

- `docs/std`
- `docs/lute`

The docs note that generation is driven by `docgen.luau`, which maps standard-library and definition sources into those generated pages.

## Contributor Guidance

### Ways To Contribute

The docs explicitly encourage:

- bug reports
- feature requests
- code contributions
- documentation improvements

### Repository Orientation

The contributor guide highlights these repository areas:

- source code
- type definitions
- user-facing docs
- tooling
- tests

### Style Expectations

Documented expectations include:

- format C++ with the provided `.clang-format`
- format Luau with StyLua

Additional review-time conventions:

1. public Luau APIs exposed by Lute should use `luacase`
2. internal Luau code should use `camelCase` for identifiers/fields and `PascalCase` for type names
3. functionality changes should include tests
4. tests should live alongside existing test structure and use the appropriate framework
5. small incremental contributions are preferred over sweeping changes

The docs explicitly warn that large sweeping changes may be rejected without review unless discussed first.

### PR Expectations

PR titles should read like changelog entries and be informative from the user's perspective.

Examples of good titles in the docs include:

- `Adds support for custom error handlers in the CLI`
- `Fixes memory leak in filesystem operations`

Examples explicitly called bad:

- `Update code`
- `WIP: testing changes`

The contributor guide also asks authors to apply a release-note-relevant label such as:

- `documentation`
- `std`
- `cli`
- `runtime`
- `infra`
- `bug`

### Licensing Note

By contributing code through issues or pull requests, contributors agree to license that code under MIT and assert they have the legal right to do so.

## Release Process

### Release Branching Model

Release branches use this format:

```text
release/v{Major}.{Minor}.x
```

Release tags use:

```text
v{Major}.{Minor}.{Patch}
```

The docs explain that release branches allow continued support for older versions while primary development continues elsewhere.

Release notes are explicitly described as manual.

### Working On Release Branches

Preferred practice:

- avoid manual edits on release branches when possible
- develop on primary first
- cherry-pick hotfixes and security fixes into release branches as needed
- apply manual changes to release branches only as a last resort

### Cutting a Release

The documented release workflow is centered around the GitHub Actions release job.

The docs say to select a `release/v{Major}.{Minor}.x` branch in the release workflow.

That job then:

1. checks out the release branch
2. ensures the branch passes status checks
3. derives the next `v{Major}.{Minor}.{Patch}` tag
4. builds Lute for multiple platforms
5. creates a draft release with those artifacts

The docs then remind maintainers to add patch notes manually.

### Nightly Releases

Nightlies can be scheduled or triggered manually.

Important distinction preserved from the docs:

- patch notes for nightly releases are generated automatically
