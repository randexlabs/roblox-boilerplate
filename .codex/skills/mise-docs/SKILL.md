---
name: mise-docs
description: Answer practical `mise` questions using the local `mise/` repository docs, CLI pages, config docs, plugin docs, task guides, environment guides, cookbook examples, and architecture notes. Use when working with `mise.toml`, `.tool-versions`, shell activation, shims, tool installs, env vars, tasks, plugins, backends, CI, IDE integration, troubleshooting, or extending `mise`.
---

# Mise Docs

Use this skill when the user needs source-based guidance about how `mise` works in practice.

Prefer the local repository documentation in `mise/docs/`, plus selected root docs such as `mise/README.md`, `mise/CHANGELOG.md`, and `mise/CONTRIBUTING.md`. Preserve nuance, caveats, and operational tradeoffs instead of collapsing answers into a thin command catalog.

## Workflow

1. Identify the question type before loading references.
2. Start with the matching file in `references/` to narrow the search area quickly.
3. Open the referenced source docs inside `mise/` for exact details, examples, warnings, or edge cases.
4. When behavior is still ambiguous, use `references/troubleshooting-security-and-architecture.md` to find the implementation area and then inspect the code.
5. Keep important distinctions explicit:
    - `mise activate` vs shims vs `mise exec` vs `mise run`
    - project config vs global config vs local overrides
    - modern backends/core tools vs legacy asdf plugins
    - end-user plugin usage vs plugin authoring
    - conceptual docs vs command-specific CLI pages

## Reference Map

- `references/overview-and-navigation.md`
    - Product overview, mental model, repo doc map, and first-stop navigation.
- `references/installation-shell-and-directory-behavior.md`
    - Installation, activation, shims, directory trust, direnv, IDE, shell behavior, and platform notes.
- `references/configuration-and-settings.md`
    - `mise.toml`, merge order, write targets, scopes, settings, env vars, schema, and config-related edge cases.
- `references/dev-tools-and-version-resolution.md`
    - Tool declarations, version resolution, backends, aliases, dependencies, caching, and language/runtime docs.
- `references/environments-secrets-and-templating.md`
    - `[env]`, `env._` directives, redactions, required vars, templating, secret workflows, and env plugins.
- `references/tasks-and-automation.md`
    - TOML tasks, file tasks, templates, watch mode, dependencies, task env, and task-oriented CLI pages.
- `references/cli-command-map.md`
    - Command families, subcommand routing, and where to look for exact flags/examples.
- `references/plugins-backends-and-extensibility.md`
    - Backend plugins, tool plugins, env plugins, legacy asdf plugins, publishing, and author workflows.
- `references/integrations-cookbook-and-recipes.md`
    - CI, GitHub Actions generation, direnv, MCP, OCI, sync flows, cookbook patterns, and practical integrations.
- `references/troubleshooting-security-and-architecture.md`
    - FAQ hotspots, trust/security notes, cache/debug docs, errors, architecture, testing, contributing, and version-history lookup.

## Usage Notes

- For `mise.toml` questions, start with `configuration-and-settings.md` and then open the exact source doc it points to.
- For install/activation problems, combine `installation-shell-and-directory-behavior.md` with `troubleshooting-security-and-architecture.md`.
- For tool install/version questions, combine `dev-tools-and-version-resolution.md` with `cli-command-map.md`.
- For environment loading or secret-management questions, open `environments-secrets-and-templating.md` first.
- For task behavior, read `tasks-and-automation.md` before command-specific CLI pages.
- For plugin or backend work, start with `plugins-backends-and-extensibility.md` and keep the modern-backend vs legacy-plugin distinction explicit.
- For implementation questions, use `troubleshooting-security-and-architecture.md` to jump from docs to relevant code areas.
