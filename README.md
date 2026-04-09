# roblox-boilerplate

Personal Roblox boilerplate for people who want an opinionated Luau toolchain, typed networking, tests, and a repo that treats Studio as a runtime target instead of the source of truth.

> This repository is not trying to be universal. It is built around a specific workflow.

- Windows-first local development
- source-controlled game structure through Rojo
- package management through `pesde`
- automation through `lune` and `mise`
- typed remotes generated from Blink IDL
- static analysis and tests as part of normal development

## At a Glance

| Area              | Choice        |
| ----------------- | ------------- |
| Primary OS        | Windows       |
| Recommended shell | PowerShell 7+ |
| Tool entrypoint   | `mise`        |
| Package manager   | `pesde`       |
| Studio sync       | `rojo`        |
| Local scripting   | `lune`        |
| Networking        | `blink`       |
| Analysis          | `luau-lsp`    |
| Tests             | `re-test`     |

## Quick Start

1. Install `mise`: <https://mise.jdx.dev/installing-mise.html>
2. Install the pinned toolchain:

```powershell
mise install
```

3. Install project dependencies and generate networking outputs:

```powershell
mise run setup
```

4. Verify the repository is usable:

```powershell
mise run lint
mise run tests
```

## Table of Contents

- [At a Glance](#at-a-glance)
- [Quick Start](#quick-start)
- [What This Repository Is](#what-this-repository-is)
- [Who This Repository Is For](#who-this-repository-is-for)
- [Who Should Not Use It](#who-should-not-use-it)
- [Tech Stack](#tech-stack)
- [Why These Tools](#why-these-tools)
- [Project Structure](#project-structure)
- [Setup on Windows](#setup-on-windows)
- [Development Workflow](#development-workflow)
- [Repository Constraints](#repository-constraints)
- [Current Status](#current-status)

## What This Repository Is

This is a personal boilerplate for Roblox projects that should start from a disciplined engineering baseline instead of growing out of ad-hoc Studio state.

The repo assumes:

- code lives in the filesystem first
- Studio sync is handled by Rojo
- remotes should be declared, generated, and typed
- tests should exist alongside gameplay code
- package boundaries matter
- formatting, spellchecking, and commit hygiene should be automated

It does not try to hide the toolchain. If that is a problem, this repository is the wrong starting point.

## Who This Repository Is For

This repository fits developers who already know why they want a real workflow around Roblox development.

It is for people who want:

- Luau code organized as a real repository, not as Studio-only state
- typed networking instead of loosely typed `RemoteEvent` glue
- deterministic setup through versioned tools
- source-level analysis with `luau-lsp`
- testable runtime domains with `re-test`
- explicit package management for Roblox and Lune dependencies
- a boilerplate that already makes choices instead of pretending neutrality

Typical fit:

- experienced Roblox developers tired of weak project setup
- engineers coming from non-Roblox ecosystems who expect local tooling and reproducibility
- solo developers or small teams who want one stack, one workflow, and low ambiguity

## Who Should Not Use It

Do not use this repository if you want:

- a beginner template that teaches Roblox from zero
- a Studio-only workflow
- a template with no opinion on packages, tests, remotes, or repo layout
- a setup optimized for drag-and-drop iteration over engineering discipline
- a cross-platform-first onboarding flow

This boilerplate is selective on purpose. The value is in the constraints.

## Tech Stack

### Tooling

| Tool                    | Role                                                          |
| ----------------------- | ------------------------------------------------------------- |
| `mise`                  | versioned tool installer and task runner                      |
| `pesde`                 | package manager for Roblox and Lune ecosystems                |
| `rojo`                  | filesystem-to-Studio project mapping and sourcemap generation |
| `lune`                  | Luau runtime for local scripts and automation                 |
| `blink`                 | IDL compiler for typed Roblox networking                      |
| `luau-lsp`              | static analysis using generated defs and sourcemap inputs     |
| `re-test`               | Luau test runner used through `pesde x ernisto/test -- tests` |
| `stylua`                | Luau formatter                                                |
| `prettier`              | formatting for Markdown, JSON, TOML, YAML                     |
| `cspell`                | repository-wide spellchecking                                 |
| `husky` + `lint-staged` | pre-commit enforcement for formatting and text hygiene        |

### Declared runtime packages

The current `pesde.toml` includes:

- `vide`: opinionated reactive UI/runtime layer
- `profilestore`: persistent player profile storage
- `conch` and `conch_ui`: command/console tooling
- `topbarplus`: top bar UI support
- `quickzone`: zone-based spatial detection
- `rng`: random utilities

These are not listed to look impressive. They reflect the runtime direction this boilerplate is prepared for.

## Why These Tools

### `mise`

`mise` is the entrypoint because it solves two practical problems cleanly:

- pinning tool versions in-repo
- exposing a single task surface for setup, lint, tests, and dev loops

Without it, setup degrades into undocumented machine assumptions.

### `pesde`

`pesde` is here because Roblox projects still need real dependency management, and ad-hoc vendoring does not scale once the codebase starts to split across runtime packages, tooling packages, and test support.

This repository uses `pesde` for:

- Roblox package dependencies
- Lune-side tooling dependencies
- reproducible installs

### `rojo`

`rojo` is non-negotiable in this workflow. The project tree is defined in [`default.project.json`](/C:/Users/cayasde/Projects/rb/default.project.json), not improvised inside Studio.

It gives this repository:

- deterministic mapping from filesystem to DataModel
- `rojo serve` for live sync
- `rojo sourcemap` for static analysis support

### `lune`

`lune` is used for local Luau scripting that should not live inside Studio. In this repo it is part of the automation layer, including definition generation.

That matters because repo automation should stay close to the language used by the project, not jump to another runtime unless there is a concrete reason.

### `blink`

`blink` exists here to stop remote contracts from turning into untyped noise.

This repo uses Blink to generate client/server networking code from the definitions in `remotes/.blink`, producing generated Luau outputs under `remotes/`.

That gives you one contract surface instead of duplicated remote assumptions.

### `luau-lsp`

`luau-lsp` is used as actual analysis infrastructure, not editor decoration. The configured lint task depends on:

- generated Roblox defs
- platform-aware analysis
- explicit ignore rules for vendored packages

That is materially better than pretending types exist while never analyzing the repository as a whole.

### `re-test`

The repo already uses mirrored test structure under [`tests`](/C:/Users/cayasde/Projects/rb/tests), with coverage expected to follow runtime domains.

The point of `re-test` here is simple: runtime domains should be testable without turning the project into framework theater.

## Project Structure

The repository is split by runtime boundary and support function, not by random folder taste.

```text
.
├─ src/
│  ├─ ReplicatedFirst/
│  ├─ ReplicatedStorage/
│  ├─ ServerScriptService/
│  └─ StarterPlayerScripts/
├─ tests/
├─ remotes/
├─ libs/
├─ stories/
├─ assets/
├─ roblox_packages/
├─ roblox_server_packages/
├─ luau_packages/
├─ lune_packages/
├─ docs/
├─ scripts/
├─ default.project.json
├─ mise.toml
└─ pesde.toml
```

### `src`

`src` maps into the Roblox DataModel through Rojo.

Current high-value domain:

- [`src/ServerScriptService/profiles`](/C:/Users/cayasde/Projects/rb/src/ServerScriptService/profiles): player profile loading, caching, waiting, public access, runtime/session/store split

The other runtime roots currently exist as explicit placeholders with local `README.md` files. That is acceptable in a boilerplate. It becomes a problem only if they stay vague once real client/runtime domains are added.

### `tests`

`tests` mirrors runtime domains instead of becoming a dumping ground.

Current implemented area:

- [`tests/ServerScriptService/profiles`](/C:/Users/cayasde/Projects/rb/tests/ServerScriptService/profiles)

That structure is correct because it keeps tests adjacent in meaning even when they are physically separate from runtime code.

### `remotes`

`remotes` holds Blink inputs and generated networking outputs. This is where network contracts are defined and compiled, rather than scattered across arbitrary scripts.

### `libs`

`libs` contains small shared Luau modules such as cleanup, backoff, object pooling, and Discord webhook support.

The current shape matches the repo docs: individual files with focused purpose are preferred over giant utility blobs.

### `stories`

`stories` is the UI/playground surface. Right now it is minimal, which is fine. Minimal and intentional is better than fake completeness.

### `assets`

`assets` is split into media categories and currently mostly seeded with placeholders. That is normal for a boilerplate; the folder exists to keep future content organized before entropy starts.

### package directories

These directories exist because the repo uses package-based workflows:

- `roblox_packages`
- `roblox_server_packages`
- `luau_packages`
- `lune_packages`

These directories are generated and maintained by `pesde`.

They are support surfaces, not the product. If these folders are bigger than your actual game code forever, the project is stalling.

## Setup on Windows

### Prerequisites

You should already have:

- Git
- PowerShell
- Roblox Studio

This repository expects Windows as the primary environment. It does not optimize onboarding for macOS or Linux.
Other shells are usable, but PowerShell 7+ is the recommended shell in this workflow.

### Install tools

Install `mise` first. After that, let the repository install the pinned toolchain.

Install guide:

- <https://mise.jdx.dev/installing-mise.html>

```powershell
mise install
```

This reads [`mise.toml`](/C:/Users/cayasde/Projects/rb/mise.toml) and installs the versions pinned by the repo, including:

- `rojo`
- `pesde`
- `lune`
- `blink`
- `luau-lsp`
- `stylua`
- `prettier`
- `pnpm`

### Install repository dependencies

Run the setup task from the repo root:

```powershell
mise run setup
```

Current behavior of that task:

1. `mise i`
2. `pesde install`
3. `pnpm install`
4. `blink remotes/.blink`

That means setup is not just package installation. It also generates the remote outputs expected by the project.

### Verify the setup

At minimum, confirm these commands work:

```powershell
mise run lint
mise run tests
```

If `lint` works, the following are functioning together:

- generated Roblox defs
- sourcemap generation
- `luau-lsp` analysis
- repository path/config assumptions

If `tests` works, your package resolution and test runner setup are in usable shape.

## Development Workflow

This repo already exposes the useful tasks through `mise`. Use them instead of memorizing raw tool invocations unless you are debugging the pipeline itself.

### Start the local dev loop

```powershell
mise run dev
```

Recommended when actively building gameplay or iterating on networking.

This flow is built from:

- `ropen` for opening the configured places
- `rojo serve`
- `rojo sourcemap --watch`
- `blink remotes/.blink -w`

So the dev loop is not just sync. It also keeps analysis inputs and generated remotes current while you work.

### Run analysis

```powershell
mise run lint
```

Recommended before opening or updating a PR.

This task:

- regenerates Roblox defs when needed
- regenerates `sourcemap.json`
- runs `luau-lsp analyze` with the Roblox platform selected
- ignores vendored package folders during analysis

### Run tests

```powershell
mise run tests
```

Current command:

```powershell
pesde x ernisto/test -- tests
```

That means tests are expected to live under the repository `tests` tree and be executable from repo root.

### Run the full check pipeline

```powershell
mise run check
```

Recommended before pushing when you want one gate instead of several manual commands.

This chains:

- lint
- tests
- format

### Regenerate Roblox definition files

```powershell
mise run ensure_roblox_defs
```

This updates:

- [`globalTypes.d.luau`](/C:/Users/cayasde/Projects/rb/globalTypes.d.luau)
- [`vectorTypes.d.luau`](/C:/Users/cayasde/Projects/rb/vectorTypes.d.luau)

Those files are inputs to analysis. If they are stale, the analysis surface is worse.

## Repository Constraints

Read the repo docs before adding conventions that fight the current setup.

- [`docs/index.md`](/C:/Users/cayasde/Projects/rb/docs/index.md): entrypoint for repo-curated docs
- [`SECURITY.md`](/C:/Users/cayasde/Projects/rb/SECURITY.md): required when touching authority, persistence, tooling with filesystem/process/network access, or CI/release surfaces
- [`AGENTS.md`](/C:/Users/cayasde/Projects/rb/AGENTS.md): repo-local execution and formatting expectations for coding agents

The repo already encodes opinions about structure, tooling, and verification. If you ignore those and work around them, you are just degrading the baseline.

## Current Status

This repository is a boilerplate, not a finished game framework.

Right now:

- the overall structure is in place
- the toolchain is real
- the `profiles` server domain is the most implemented runtime slice
- the client/runtime roots outside that domain are still intentionally sparse

That is a valid state for a personal boilerplate. It becomes weak only if the repository stays forever as infrastructure with no meaningful runtime expansion.
