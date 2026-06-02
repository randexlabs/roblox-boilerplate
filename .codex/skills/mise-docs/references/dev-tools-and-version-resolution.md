# Dev Tools and Version Resolution

## Table of Contents

1. Read this when
2. Primary source files
3. Core mental model
4. Version declaration forms
5. Tool options and selectors
6. Dependencies, caching, and auto-install
7. Backends and language docs
8. Useful CLI pages
9. Important caveats

## Read this when

Use this reference for:

- installing tools
- selecting versions
- understanding why a specific version is active
- comparing backends
- managing language-specific behavior
- debugging tool dependencies or cache behavior

## Primary source files

- `mise/docs/dev-tools/index.md`
- `mise/docs/core-tools.md`
- `mise/docs/registry.md`
- `mise/docs/dev-tools/aliases.md`
- `mise/docs/dev-tools/deps.md`
- `mise/docs/dev-tools/mise-lock.md`
- `mise/docs/dev-tools/mise-oci.md`
- `mise/docs/dev-tools/shims.md`
- `mise/docs/dev-tools/backends/index.md`
- `mise/docs/dev-tools/backends/*.md`
- `mise/docs/lang/*.md`
- `mise/docs/cache-behavior.md`
- `mise/docs/faq.md`

## Core mental model

The dev tools docs explain more than commands:

- tool resolution is a flow, not a single lookup
- environment integration matters because tools can affect env/PATH
- path management is a core part of the experience
- config hierarchy influences active tool versions

When a user asks "why did `mise` pick this version?", read `mise/docs/dev-tools/index.md` before answering.

## Version declaration forms

Common forms documented across the repo include:

- exact versions such as `node@20.19.0`
- prefix/major selectors such as `node@20`
- moving selectors such as `latest` and `lts`
- refs like `ref:main`
- prefixes like `prefix:1.19`
- paths such as `path:/custom/install`

Important nuance from the FAQ:

- users often assume `latest` or `node@20` always means the newest remote artifact
- the docs distinguish available remote versions, resolved local state, and what is written into config

## Tool options and selectors

The docs preserve several practical capabilities:

- table format in `[tools]`
- dotted notation and nested configuration
- postinstall commands
- OS-specific selectors
- OS/architecture combinations
- per-tool dependencies
- vfox-specific hook dependency behavior

Read next:

- `mise/docs/dev-tools/index.md`
- `mise/docs/plugins.md`
- backend-specific docs in `mise/docs/dev-tools/backends/`

## Dependencies, caching, and auto-install

Important topics:

- tool dependencies
- cache behavior and performance
- automatic install on demand
- command-not-found handler integration
- shims and command resolution

Relevant docs:

- `mise/docs/dev-tools/index.md`
- `mise/docs/cache-behavior.md`
- `mise/docs/dev-tools/shims.md`
- `mise/docs/cli/cache*.md`
- `mise/docs/cli/prune.md`

## Backends and language docs

Backend docs live in:

- `mise/docs/dev-tools/backends/aqua.md`
- `mise/docs/dev-tools/backends/asdf.md`
- `mise/docs/dev-tools/backends/cargo.md`
- `mise/docs/dev-tools/backends/conda.md`
- `mise/docs/dev-tools/backends/dotnet.md`
- `mise/docs/dev-tools/backends/forgejo.md`
- `mise/docs/dev-tools/backends/gem.md`
- `mise/docs/dev-tools/backends/github.md`
- `mise/docs/dev-tools/backends/gitlab.md`
- `mise/docs/dev-tools/backends/go.md`
- `mise/docs/dev-tools/backends/http.md`
- `mise/docs/dev-tools/backends/npm.md`
- `mise/docs/dev-tools/backends/pipx.md`
- `mise/docs/dev-tools/backends/s3.md`
- `mise/docs/dev-tools/backends/spm.md`
- `mise/docs/dev-tools/backends/ubi.md`
- `mise/docs/dev-tools/backends/vfox.md`

Language-oriented runtime docs live in:

- `mise/docs/lang/bun.md`
- `mise/docs/lang/deno.md`
- `mise/docs/lang/dotnet.md`
- `mise/docs/lang/elixir.md`
- `mise/docs/lang/erlang.md`
- `mise/docs/lang/go.md`
- `mise/docs/lang/java.md`
- `mise/docs/lang/node.md`
- `mise/docs/lang/python.md`
- `mise/docs/lang/ruby.md`
- `mise/docs/lang/rust.md`
- `mise/docs/lang/swift.md`
- `mise/docs/lang/zig.md`

Use backend docs for install mechanics and runtime docs for ecosystem-specific workflows.

## Useful CLI pages

- `mise/docs/cli/use.md`
- `mise/docs/cli/install.md`
- `mise/docs/cli/upgrade.md`
- `mise/docs/cli/ls.md`
- `mise/docs/cli/ls-remote.md`
- `mise/docs/cli/which.md`
- `mise/docs/cli/where.md`
- `mise/docs/cli/latest.md`
- `mise/docs/cli/outdated.md`
- `mise/docs/cli/tool.md`
- `mise/docs/cli/backends.md`
- `mise/docs/cli/backends/ls.md`

## Important caveats

- `mise use` and `mise install` are not the same operation.
- Active version resolution and config write behavior are separate concerns.
- Core tools / modern backends are generally preferred over legacy plugin-only flows.
- Cache state can affect what users perceive as "latest" or "available".
