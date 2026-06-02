# Overview and Navigation

## Table of Contents

1. Product framing
2. Core mental model
3. High-value source files
4. Documentation zones
5. Fast routing guide
6. Context worth preserving

## Product framing

`mise` is presented as "the work before the work": one CLI that prepares a development environment before commands run. The core framing appears consistently across the repo:

- Dev tools: install, pin, and switch languages/tools.
- Environments: load project-scoped environment variables from config, dotenv files, shell snippets, and plugins.
- Tasks: define build/test/lint/deploy workflows next to the tools and env they need.

The docs repeatedly emphasize that these three pillars belong together in the same workflow, usually centered on `mise.toml`.

## Core mental model

Use this mental model when answering:

- `mise` is not only a version manager.
- `mise.toml` is the main integration point for tools, env, and tasks.
- The shell experience matters: activation, shims, and direct execution are separate mechanisms with different tradeoffs.
- Much of the repo's advice is practical and opinionated, not just mechanical reference material.

## High-value source files

Start here when orienting:

- `mise/README.md`
    - Best high-level practical introduction with quickstart examples.
- `mise/docs/index.md`
    - Home/landing page with the "mise en place" metaphor and product shape.
- `mise/docs/getting-started.md`
    - Primary onboarding path.
- `mise/docs/faq.md`
    - High-value operational clarifications and tradeoffs.
- `mise/llms.txt`
    - A compact repo-authored summary that helps confirm terminology and common workflows.

## Documentation zones

### Core docs

- `mise/docs/configuration.md`
- `mise/docs/getting-started.md`
- `mise/docs/installing-mise.md`
- `mise/docs/directories.md`
- `mise/docs/errors.md`
- `mise/docs/faq.md`
- `mise/docs/cache-behavior.md`
- `mise/docs/architecture.md`

### Dev tools

- `mise/docs/dev-tools/index.md`
- `mise/docs/dev-tools/backends/*.md`
- `mise/docs/lang/*.md`
- `mise/docs/core-tools.md`
- `mise/docs/registry.md`

### Environments

- `mise/docs/environments/index.md`
- `mise/docs/environments/secrets/*.md`
- `mise/docs/configuration/environments.md`

### Tasks

- `mise/docs/tasks/*.md`
- `mise/docs/tasks.md`
- `mise/tasks.md`

### CLI reference

- `mise/docs/cli/**/*.md`
- `mise/docs/mise.usage.kdl`
- `mise/mise.usage.kdl`

### Plugins and extensibility

- `mise/docs/plugins.md`
- `mise/docs/plugin-usage.md`
- `mise/docs/plugin-publishing.md`
- `mise/docs/plugin-lua-modules.md`
- `mise/docs/backend-plugin-development.md`
- `mise/docs/env-plugin-development.md`
- `mise/docs/asdf-legacy-plugins.md`

### Integrations and recipes

- `mise/docs/continuous-integration.md`
- `mise/docs/ide-integration.md`
- `mise/docs/direnv.md`
- `mise/docs/mcp.md`
- `mise/docs/mise-cookbook/*.md`

## Fast routing guide

- "What is `mise` / how do I start?" -> `mise/README.md`, `mise/docs/getting-started.md`
- "Why is config behaving this way?" -> `configuration-and-settings.md`
- "Why did it choose this tool version?" -> `dev-tools-and-version-resolution.md`
- "Why are env vars not loading?" -> `environments-secrets-and-templating.md`
- "How should I define or run tasks?" -> `tasks-and-automation.md`
- "Which command/flag handles this?" -> `cli-command-map.md`
- "Should I use a plugin or backend?" -> `plugins-backends-and-extensibility.md`
- "How do I wire this into CI/editor/direnv?" -> `integrations-cookbook-and-recipes.md`
- "I need debugging, trust, security, or code internals." -> `troubleshooting-security-and-architecture.md`

## Context worth preserving

These repo-level contextual cues are useful in future answers:

- The docs are intentionally practical, not purely theoretical.
- The author strongly prefers modern built-in backends/core tools over legacy plugin-heavy flows when possible.
- Tasks are treated as a first-class project automation system, not an afterthought.
- The repo includes both user docs and contributor/architecture docs, so the right answer often requires choosing the correct layer.
