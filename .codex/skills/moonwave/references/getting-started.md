# Getting Started

## Installation

Moonwave's public docs say to install Node.js first, then install the CLI globally:

```bash
npm i -g moonwave
```

To always use the latest version without a global install:

```bash
npx moonwave dev
```

The docs mention Node.js `v18+` for normal use. The repository development notes mention Node.js `20+` for contributing to Moonwave itself. For users of the published CLI, follow the public docs unless a specific release says otherwise.

## Basic First Run

From your project root:

```bash
moonwave dev
```

This starts a local development website with live reload.

If your source code is not under `src` or `lib`, specify one or more code roots:

```bash
moonwave dev --code source
moonwave dev --code packages --code src
```

## Minimal Project Structure

For the common flow, Moonwave can work with only:

- your Lua/Luau source files
- doc comments inside those files
- an optional `README.md`

Useful optional folders and files:

- `moonwave.toml` or `moonwave.json`
- `docs/`
- `blog/`
- `pages/`
- `.moonwave/static/`
- `.moonwave/custom.css`
- `.moonwave/sidebars.js`
- `CHANGELOG.md`

## Smallest Useful Example

```lua
--- @class MyFirstClass
---
--- This is my first class.
local MyFirstClass = {}
MyFirstClass.__index = MyFirstClass

--- Adds two numbers.
--- @param a number -- The first number
--- @param b number -- The second number
--- @return number -- The sum
function MyFirstClass:add(a, b)
	return a + b
end
```

That class should appear in the generated API after `moonwave dev` runs successfully.

## Build And Publish

Build a static site:

```bash
moonwave build
```

Build to a custom output directory:

```bash
moonwave build --out-dir dist-docs
```

Build and publish to `gh-pages`:

```bash
moonwave build --publish
```

## What The CLI Does Behind The Scenes

During dev or build, the CLI:

1. Reads config and Git metadata.
2. Builds a cached Docusaurus workspace.
3. Copies over your docs/blog/pages/static assets.
4. Generates homepage and changelog pages when applicable.
5. Downloads or reuses a platform-specific `moonwave-extractor` binary.
6. Runs the Docusaurus dev server or build pipeline.

This matters when debugging because failures can come from cached state, extracted docs, Docusaurus config, or your source comments.
