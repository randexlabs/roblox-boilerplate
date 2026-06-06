# Moonwave Overview

## What Moonwave Is

Moonwave generates documentation websites from comments written in Lua or Luau source files.

Its public developer experience is split across three parts:

1. The `moonwave` CLI creates and prepares a Docusaurus site, copies project content into a temporary site workspace, and runs dev/build flows.
2. The `moonwave-extractor` Rust binary parses Lua/Luau source files and emits structured JSON describing classes, functions, properties, and types.
3. The `docusaurus-plugin-moonwave` plugin reads that JSON and turns it into API pages inside Docusaurus.

The common path is to install the CLI and use `moonwave dev` or `moonwave build`. The CLI hides the extractor and plugin details unless you need deeper control.

## Product Model

Moonwave assumes that API documentation is organized around "classes". A Moonwave class is just a documentation grouping for a table-like API surface. It does not require object-oriented runtime behavior.

Moonwave also supports:

- Markdown docs through a project `docs/` folder
- A Docusaurus blog through a project `blog/` folder
- Custom hosted pages through a project `pages/` folder
- A generated or customized homepage
- Static assets and custom CSS through a project `.moonwave/` folder

## What It Is Good At

- Fast setup for Lua/Luau API docs
- Keeping docs close to source through doc comments
- Combining API reference with hand-written docs, blog posts, and custom pages
- Publishing to GitHub Pages with minimal setup
- Producing structured JSON that other tools can consume

## Important Defaults

- The CLI defaults `--code` to `lib` and `src`.
- If `README.md` exists and no custom homepage is enabled, the README becomes the homepage.
- If `CHANGELOG.md` exists and changelog support is enabled, it becomes a generated page.
- Git metadata is used to infer defaults like title, repo URL, organization name, project name, and default GitHub Pages URLs.

## Architecture Notes That Matter In Practice

- Moonwave builds a temporary Docusaurus project in a cache directory instead of mutating your repo into a Docusaurus app directly.
- The CLI installs site dependencies into that cached workspace on first run or after invalidation.
- The extractor is downloaded automatically by the CLI for supported platforms unless development overrides are set.
- The plugin watches `*.lua` and `*.luau` files under the configured code roots.

## When To Treat Source As Authoritative

The website docs cover most day-to-day usage, but some real behavior is only clear in code:

- `moonwave.json` is accepted alongside `moonwave.toml`.
- `classOrder` has validation rules that are stricter when `autoSectionPath` is enabled.
- The plugin builds source links from `gitRepoUrl` plus `gitSourceBranch`, defaulting the branch to `master`.
- The home page README include option can point at a custom file path, not just a boolean.
