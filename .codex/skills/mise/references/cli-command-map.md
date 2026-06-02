# CLI Command Map

## Table of Contents

1. Read this when
2. Primary source files
3. Global command model
4. Command families
5. High-value command pairings
6. Supporting machine-readable sources

## Read this when

Use this reference when the user needs:

- the right `mise` command for an action
- exact flags, arguments, or subcommands
- command-family navigation instead of broad conceptual docs

## Primary source files

- `mise/docs/cli/index.md`
- `mise/docs/cli/**/*.md`
- `mise/docs/mise.usage.kdl`
- `mise/mise.usage.kdl`

## Global command model

Open `mise/docs/cli/index.md` first for:

- the top-level `mise` command model
- global flags such as `--cd`, `--jobs`, `--quiet`, `--verbose`, `--raw`, `--locked`
- disabling config/env/hooks with `--no-config`, `--no-env`, `--no-hooks`

## Command families

### Environment and shell

- `activate`
- `deactivate`
- `env`
- `set`
- `unset`
- `shell`
- `shell-alias`
- `trust`
- `untrust`
- `completion`

### Tool installation and resolution

- `use`
- `install`
- `upgrade`
- `uninstall`
- `unuse`
- `ls`
- `ls-remote`
- `latest`
- `outdated`
- `which`
- `where`
- `tool`
- `backends`

### Config and settings

- `config`
- `config get`
- `config ls`
- `config set`
- `settings`
- `settings add`
- `settings get`
- `settings ls`
- `settings set`
- `settings unset`
- `edit`
- `fmt`

### Tasks and dependency workflows

- `run`
- `watch`
- `tasks`
- `tasks add`
- `tasks deps`
- `tasks edit`
- `tasks info`
- `tasks ls`
- `tasks run`
- `tasks validate`
- `deps`
- `deps add`
- `deps install`
- `deps remove`

### Plugins and backend extension

- `plugins`
- `plugins install`
- `plugins link`
- `plugins ls`
- `plugins ls-remote`
- `plugins uninstall`
- `plugins update`

### Cache, diagnostics, and maintenance

- `cache`
- `cache clear`
- `cache path`
- `cache prune`
- `doctor`
- `doctor path`
- `prune`
- `reshim`
- `self-update`
- `version`

### Generation and integration helpers

- `generate`
- `generate bootstrap`
- `generate config`
- `generate devcontainer`
- `generate git-pre-commit`
- `generate github-action`
- `generate task-docs`
- `generate task-stubs`
- `generate tool-stub`
- `sync`
- `sync node`
- `sync python`
- `sync ruby`
- `mcp`
- `oci`
- `oci build`
- `oci push`
- `oci run`

### Miscellaneous or specialized

- `bin-paths`
- `install-into`
- `link`
- `lock`
- `registry`
- `search`
- `test-tool`
- `token`
- `tool-alias`
- `en`

## High-value command pairings

Use these command clusters together when troubleshooting:

- install state: `use`, `install`, `ls`, `ls-remote`, `which`, `where`
- config state: `config`, `settings`, `env`, `trust`
- setup validation: `doctor`, `doctor path`, `env`
- task state: `tasks info`, `tasks validate`, `run`, `watch`
- cache/debug state: `cache path`, `cache clear`, `prune`

## Supporting machine-readable sources

If the prose docs are unclear about command shape, inspect:

- `mise/docs/mise.usage.kdl`
- `mise/mise.usage.kdl`

These are useful for checking command inventory and generated usage structure.
