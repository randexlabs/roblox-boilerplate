# Environments, Secrets, and Templating

## Table of Contents

1. Read this when
2. Primary source files
3. Core environment model
4. High-value features
5. `env._` directives
6. Secrets and plugin-provided env
7. Tasks interaction
8. Important caveats

## Read this when

Use this reference for:

- `[env]` behavior
- dotenv and sourced-file loading
- env templating and interpolation
- required env vars
- redacted secrets
- secret management workflows
- env plugins

## Primary source files

- `mise/docs/environments/index.md`
- `mise/docs/environments/secrets/index.md`
- `mise/docs/environments/secrets/age.md`
- `mise/docs/environments/secrets/sops.md`
- `mise/docs/configuration/environments.md`
- `mise/docs/env-plugin-development.md`
- `mise/docs/plugins.md`
- `mise/docs/cli/env.md`
- `mise/docs/cli/set.md`
- `mise/docs/cli/unset.md`

## Core environment model

The environment docs describe `mise` env handling as more than static key/value storage:

- environment variables can come from config, files, shell commands, plugins, and templates
- env behavior interacts with tools and tasks
- the docs emphasize source visibility and traceability

Useful commands:

```sh
mise set KEY=value
mise env
mise env -s bash
```

## High-value features

The main environment guide contains unusually valuable operational detail. Preserve these topics:

- environment variables used inside other environment variables
- shell-style variable expansion
- lazy evaluation
- redaction controls
- viewing redacted values intentionally
- required variable declarations and validation behavior
- `config_root` and path resolution semantics

These are common sources of subtle bugs, so prefer opening the exact source docs before answering edge cases.

## `env._` directives

This is a core feature area. The main guide documents:

- `env._.file`
- `env._.path`
- `env._.source`
- multiple `env._` directives together
- plugin-provided `env._` directives

These directives are where many "why didn't this env load?" problems originate.

## Secrets and plugin-provided env

Relevant secret-management docs:

- `mise/docs/environments/secrets/index.md`
- `mise/docs/environments/secrets/age.md`
- `mise/docs/environments/secrets/sops.md`

Relevant plugin docs:

- `mise/docs/plugins.md`
- `mise/docs/env-plugin-development.md`

Preserve the conceptual distinction:

- secret storage/decryption workflow
- runtime env loading
- plugin-supplied dynamic environment behavior

## Tasks interaction

Environment and tasks are tightly coupled. When the user mixes the two, also read:

- `mise/docs/tasks/index.md`
- `mise/docs/cli/run.md`
- `mise/docs/cli/watch.md`

The repo explicitly notes that tasks launched with `mise` include the `mise` environment.

## Important caveats

- activation and `mise env` integration can change when required variable failures appear as warnings vs hard failures
- secret redaction behavior matters for debugging and output inspection
- path resolution is relative to config roots in ways users often miss
- env plugin behavior should not be confused with tool plugin behavior
