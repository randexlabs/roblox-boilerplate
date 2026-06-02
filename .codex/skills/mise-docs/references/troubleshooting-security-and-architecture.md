# Troubleshooting, Security, and Architecture

## Table of Contents

1. Read this when
2. Primary source files
3. FAQ hotspots
4. Debugging flow
5. Security and trust
6. Architecture and code navigation
7. Test and contributor context
8. Version-history lookup

## Read this when

Use this reference for:

- diagnosing unexpected behavior
- trust/security questions
- cache/path/debug issues
- mapping a documented behavior to implementation areas
- contributor-facing questions
- version-specific historical context

## Primary source files

- `mise/docs/faq.md`
- `mise/docs/errors.md`
- `mise/docs/cache-behavior.md`
- `mise/docs/paranoid.md`
- `mise/docs/architecture.md`
- `mise/CONTRIBUTING.md`
- `mise/CHANGELOG.md`
- `mise/docs/contributing.md`
- `mise/SECURITY.md`

## FAQ hotspots

High-value FAQ topics include:

- ignored config files and `mise trust`
- `mise install` vs `mise use`
- meaning of `latest`
- asdf migration and compatibility
- activation vs shims vs `mise exec` vs `mise env`
- Windows support
- proxy usage
- CLI color behavior
- plugin shorthand naming
- versioning semantics

When a user sounds confused about a subtle behavioral distinction, the FAQ is often the fastest authoritative source.

## Debugging flow

Useful commands to keep in mind:

```sh
mise doctor
mise doctor path
mise config
mise env
mise which <tool>
mise cache path
mise cache clear
```

Use this sequence:

1. confirm config resolution
2. confirm trust state
3. confirm environment export behavior
4. confirm tool resolution and actual binary path
5. inspect cache/path behavior if resolution still looks stale

## Security and trust

Relevant docs:

- `mise/docs/paranoid.md`
- `mise/SECURITY.md`
- `mise/docs/plugins.md`
- `mise/docs/faq.md`

Important context to preserve:

- trust is a real security boundary, not arbitrary friction
- plugin choice has security implications
- the repo gives stronger warnings around some plugin workflows than many users expect

## Architecture and code navigation

`mise/docs/architecture.md` is the main bridge from user docs to implementation.

Key implementation areas called out there:

- `src/cli/`
- `src/backend/`
- `src/config/`
- `src/toolset/`
- `src/task/`
- `src/plugins/`
- `src/shell/`
- `src/env*.rs`
- `src/cache.rs`
- `e2e/`
- `e2e-win/`

Use this when the user asks:

- "where is this implemented?"
- "why does this behavior exist?"
- "how is this tested?"

## Test and contributor context

Relevant source files:

- `mise/CONTRIBUTING.md`
- `mise/docs/contributing.md`
- `mise/docs/architecture.md`
- `mise/.github/workflows/`

These are useful for:

- contributor workflow questions
- understanding test layout
- matching documented behavior to E2E coverage

## Version-history lookup

Use `mise/CHANGELOG.md` only when the question is version-sensitive.

Good use cases:

- "when was this command added?"
- "did behavior change recently?"
- "is this regression expected in newer releases?"

Do not start with the changelog for normal usage questions; it is too large and too noisy.
