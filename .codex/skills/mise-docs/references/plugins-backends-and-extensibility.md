# Plugins, Backends, and Extensibility

## Table of Contents

1. Read this when
2. Primary source files
3. Strategic guidance from the repo
4. Plugin categories
5. Authoring docs
6. Supporting code/docs
7. Important caveats

## Read this when

Use this reference for:

- deciding whether to use a plugin at all
- comparing backend plugins, tool plugins, and env plugins
- working with asdf compatibility
- plugin authoring or publishing
- advanced backend behavior

## Primary source files

- `mise/docs/plugins.md`
- `mise/docs/plugin-usage.md`
- `mise/docs/plugin-publishing.md`
- `mise/docs/plugin-lua-modules.md`
- `mise/docs/backend-plugin-development.md`
- `mise/docs/env-plugin-development.md`
- `mise/docs/asdf-legacy-plugins.md`
- `mise/docs/dev-tools/backends/*.md`
- `mise/docs/core-tools.md`
- `mise/docs/registry.md`

## Strategic guidance from the repo

This is one of the clearest opinionated areas in the docs:

- plugins are an extension mechanism, but not always the preferred solution
- modern built-in backends and core tools are preferred when they can do the job
- tool plugins should often be avoided for security reasons unless they solve a real gap
- aqua is explicitly preferred over github in some integration scenarios due to UX and feature advantages

Do not flatten this into "plugins are supported." The repo gives stronger practical guidance than that.

## Plugin categories

### Backend plugins

Characteristics preserved in the docs:

- may manage multiple tools
- use `plugin:tool` addressing
- provide modern backend methods
- are cross-platform and faster than older shell-based approaches

### Tool plugins

Characteristics preserved in the docs:

- traditional hook-based approach
- typically one plugin per tool
- flexible, but more security/maintenance tradeoffs

### Environment plugins

Characteristics preserved in the docs:

- provide env vars and PATH modifications
- do not manage tool versions
- are activated with `env._.<plugin-name>`
- fit secret managers and dynamic configuration use cases

### Legacy asdf plugins

Important nuance:

- supported for compatibility
- limited compared with modern backends
- slower
- Linux/macOS oriented

## Authoring docs

Use these when the user is building extensions:

- `mise/docs/backend-plugin-development.md`
- `mise/docs/env-plugin-development.md`
- `mise/docs/plugin-publishing.md`
- `mise/docs/plugin-lua-modules.md`

The docs separate end-user plugin consumption from plugin author workflows. Preserve that distinction.

## Supporting code/docs

Potentially relevant supporting material:

- `mise/crates/vfox/README.md`
- `mise/crates/aqua-registry/README.md`
- `mise/registry/`
- `mise/docs/registry.toml`

Use these when the public docs need deeper implementation or registry context.

## Important caveats

- "Plugin support exists" is not enough; choose the right plugin category.
- Plugin workflows and backend workflows overlap but are not identical.
- Environment plugins should not be described as tool installers.
- Legacy asdf guidance is still useful, but should not be presented as the default modern path.
