# Tasks and Automation

## Table of Contents

1. Read this when
2. Primary source files
3. Core task model
4. TOML tasks vs file tasks
5. Task execution features
6. Task environment
7. Command docs to open next
8. Practical author context

## Read this when

Use this reference for:

- defining tasks
- deciding between TOML tasks and file tasks
- running, validating, or watching tasks
- understanding task dependencies
- debugging task environment/context

## Primary source files

- `mise/docs/tasks/index.md`
- `mise/docs/tasks/toml-tasks.md`
- `mise/docs/tasks/file-tasks.md`
- `mise/docs/tasks/running-tasks.md`
- `mise/docs/tasks/task-configuration.md`
- `mise/docs/tasks/task-dependencies.md`
- `mise/docs/tasks/task-output.md`
- `mise/docs/tasks/task-environment.md`
- `mise/docs/tasks/templates.md`
- `mise/docs/tasks.md`
- `mise/tasks.md`
- `mise/docs/cli/run.md`
- `mise/docs/cli/watch.md`
- `mise/docs/cli/tasks.md`
- `mise/docs/cli/tasks/*.md`

## Core task model

The docs position tasks as first-class project automation:

- build, test, lint, deploy, and daily workflows live beside tools and env
- `mise`-run tasks automatically inherit the `mise` environment
- tasks can be defined declaratively or as real script files

This is not just a convenience wrapper over shell commands; the docs present it as a structured automation layer.

## TOML tasks vs file tasks

Two primary authoring modes:

- TOML tasks in `[tasks.*]`
- executable files in `mise-tasks/`

Example TOML task:

```toml
[tasks.build]
description = "Build the CLI"
run = "cargo build"
```

Example file task:

```sh
#!/usr/bin/env bash
#MISE description="Build the CLI"
cargo build
```

Preserve the practical tradeoff that file tasks can be easier to lint, highlight, and maintain than large quoted shell strings.

## Task execution features

The task docs emphasize several capabilities:

- dependency handling
- parallel builds by default
- watch mode / automatic rebuilds
- last-modified checking to skip unnecessary rebuilds
- templates for reuse

Read exact semantics from the dedicated task docs instead of generalizing.

## Task environment

The task docs explicitly call out env variables passed to tasks:

- `MISE_ORIGINAL_CWD`
- `MISE_CONFIG_ROOT`
- `MISE_PROJECT_ROOT`
- `MISE_MONOREPO_ROOT`
- `MISE_TASK_NAME`
- `MISE_TASK_DIR`
- `MISE_TASK_FILE`

When users ask why a task behaves differently depending on where it was run, these variables and the config-root docs usually explain it.

## Command docs to open next

- `mise/docs/cli/run.md`
- `mise/docs/cli/watch.md`
- `mise/docs/cli/tasks.md`
- `mise/docs/cli/tasks/add.md`
- `mise/docs/cli/tasks/deps.md`
- `mise/docs/cli/tasks/edit.md`
- `mise/docs/cli/tasks/info.md`
- `mise/docs/cli/tasks/ls.md`
- `mise/docs/cli/tasks/run.md`
- `mise/docs/cli/tasks/validate.md`

## Practical author context

The top-level task docs preserve useful opinionated context:

- parallel dependency building is treated as a standout feature
- watch mode is intended for real everyday development, not only niche usage
- the docs value script-file ergonomics over embedding complex shell in data formats
