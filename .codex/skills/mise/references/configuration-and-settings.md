# Configuration and Settings

## Table of Contents

1. Read this when
2. Primary source files
3. Main config files
4. Merge and resolution rules
5. Write-target behavior
6. Important config sections
7. Scopes and idiomatic version files
8. Schema, settings, and env vars
9. High-risk edge cases

## Read this when

Use this reference for:

- `mise.toml` structure
- config precedence and merging
- `mise use` write behavior
- scopes such as global/local/project
- `.tool-versions` compatibility
- schema and settings lookup
- config-related environment variables

## Primary source files

- `mise/docs/configuration.md`
- `mise/docs/configuration/settings.md`
- `mise/docs/configuration/environments.md`
- `mise/docs/directories.md`
- `mise/docs/faq.md`
- `mise/docs/cli/config.md`
- `mise/docs/cli/config/get.md`
- `mise/docs/cli/config/ls.md`
- `mise/docs/cli/config/set.md`
- `mise/docs/cli/settings.md`
- `mise/docs/cli/settings/*.md`
- `mise/settings.toml`
- `mise/schema/`

## Main config files

The docs consistently treat these as the core configuration surfaces:

- project config: `mise.toml`
- local override: `mise.local.toml`
- global config: `~/.config/mise/config.toml`
- system config: `/etc/mise/config.toml`
- compatibility file: `.tool-versions`

Useful practical distinction:

- `mise.toml` is the preferred first-class format.
- `.tool-versions` exists for compatibility and migration workflows.

## Merge and resolution rules

Open `mise/docs/configuration.md` for exact details. Preserve these practical behaviors:

- config is layered, not flat
- later/more local config can override earlier/global config
- different sections merge differently

Examples explicitly called out by the docs:

- `[tools]` entries merge by tool key
- `[env]` entries merge by variable key
- task definitions can replace prior task definitions rather than shallow-merging field by field
- settings merge differently from tools/tasks/env, so avoid assuming identical behavior across sections

## Write-target behavior

Users frequently ask where `mise use` or related commands write changes.

Read:

- `mise/docs/configuration.md`
- `mise/docs/faq.md`
- `mise/docs/cli/use.md`
- `mise/docs/cli/set.md`
- `mise/docs/cli/unset.md`

Key nuance to preserve:

- read precedence and write target are related but not identical concepts
- the presence of `mise.local.toml` often changes what users expect from write operations

## Important config sections

The configuration docs treat these as first-class sections:

- `[tools]`
- `[env]`
- `[tasks.*]`
- `[settings]`
- `[plugins]`
- `[tool_alias]`
- `[shell_alias]`

If the user asks about a section-specific behavior, answer from the exact source doc instead of generalizing from another section.

## Scopes and idiomatic version files

Important related topics:

- version scopes and selectors
- idiomatic version file support such as `.nvmrc`, `.python-version`, `package.json`, `global.json`, and language-specific files
- minimum supported `mise` version declarations
- experimental monorepo root behavior

Relevant docs:

- `mise/docs/configuration.md`
- `mise/docs/faq.md`
- `mise/docs/dev-tools/index.md`

## Schema, settings, and env vars

High-value supporting assets:

- `mise/settings.toml`
    - authoritative settings inventory
- `mise/schema/`
    - schema material for config validation and tooling
- `mise/docs/configuration/settings.md`
    - settings explanation

Important config-level env vars include:

- `MISE_DATA_DIR`
- `MISE_CACHE_DIR`
- `MISE_TMP_DIR`
- `MISE_SYSTEM_CONFIG_DIR`
- `MISE_GLOBAL_CONFIG_FILE`
- `MISE_DEFAULT_CONFIG_FILENAME`
- `MISE_GLOBAL_CONFIG_ROOT`
- `MISE_ENV_FILE`
- `MISE_TRUSTED_CONFIG_PATHS`
- `MISE_CEILING_PATHS`
- `MISE_LOG_LEVEL`
- `MISE_LOG_FILE`

Use the docs for exact semantics rather than paraphrasing from memory.

## High-risk edge cases

Be explicit about these:

- config merge expectations are section-dependent
- local override files may affect both resolution and write behavior
- idiomatic version files can be read alongside `mise.toml`
- monorepo behavior is not the same as a simple single-project setup
- trust-related problems can look like config resolution problems
