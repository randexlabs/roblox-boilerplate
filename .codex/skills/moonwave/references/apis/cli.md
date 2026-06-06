# Moonwave CLI API

## Top-Level Command

```bash
moonwave <command> [options]
```

Supported commands:

- `moonwave dev`
- `moonwave build`

Global flags:

- `--code <path>`: add a Lua/Luau source root; default is `lib` and `src`
- `-i`, `--install`: reinstall npm dependencies in the cached site workspace
- `-h`, `--help`: show help
- `-v`, `--version`: show version

## `moonwave dev`

```bash
moonwave dev [--fresh] [--install] [--code <path> ...]
```

Purpose:

- prepares the temporary Docusaurus workspace
- starts the dev server with live reload
- watches project files and regenerates affected content

Flags:

- `-f`, `--fresh`: delete cached build artifacts before rebuilding, while keeping cached dependencies
- `-i`, `--install`: force dependency reinstall in the cached workspace
- `--code <path>`: one or more code roots

Behavior notes:

- prints the temporary build directory path
- watches `*.lua` and `*.luau` under configured code roots through the Docusaurus plugin
- also watches config/content folders from the CLI side and regenerates the prepared project when they change

## `moonwave build`

```bash
moonwave build [--publish] [--out-dir <path>] [--install] [--code <path> ...]
```

Purpose:

- produces a static site build
- optionally publishes it to the `gh-pages` branch

Flags:

- `--publish`: publish the build directory with `gh-pages`
- `--out-dir <path>`: choose a build output directory relative to the project root; default is `build`
- `-i`, `--install`: force dependency reinstall
- `--code <path>`: one or more code roots

Behavior notes:

- always prepares the project with a fresh non-incremental content rebuild
- runs a Docusaurus `swizzle` step for `docusaurus-lunr-search` `SearchBar` before the actual build
- logs a warning not to commit the generated build directory

## Extractor Binary Management

The CLI is also responsible for obtaining `moonwave-extractor`.

Normal behavior:

- download a platform-specific binary release matching the installed CLI version
- cache it under the CLI package's `bin/` directory
- reuse it on later runs

Development overrides:

- `MOONWAVE_DEV=1` tells the CLI to use development behavior
- `MOONWAVE_EXTRACTOR_PATH` overrides the extractor path in development mode
- `MOONWAVE_PLUGIN_PATH` overrides the plugin dependency path in development mode

## Temporary Workspace Model

Moonwave does not build directly inside your project. It creates a cached Docusaurus workspace keyed by the project folder name.

This workspace contains:

- Docusaurus template files
- copied project docs/blog/pages
- copied `.moonwave` assets
- generated config
- installed npm dependencies

That design explains why `--fresh` and `--install` fix many problems.
