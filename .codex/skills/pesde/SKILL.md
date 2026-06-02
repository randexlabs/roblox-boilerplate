---
name: pesde
description: Answer practical `pesde` questions using reorganized documentation extracted from a local `pesde` docs source. Use when working with `pesde.toml`, the `pesde` CLI, installation, quickstart flows, package publishing, dependency specifiers, overrides, workspaces, Roblox usage, scripts packages, binary packages, self-hosted registries, registry policies, or release-history/troubleshooting context.
---

# Pesde

Use this skill when the user needs source-based guidance about how `pesde` works in practice.

Prefer the reorganized reference files in `references/` first. Open the original source docs only when the task needs exact wording, extra examples, or implementation-adjacent confirmation.

## Workflow

1. Identify the task type before loading references.
2. Start with the matching file in `references/` to narrow the search area quickly.
3. Preserve important distinctions instead of flattening the answer:
    - `luau`, `lune`, `roblox`, and `roblox_server`
    - package metadata vs dependency specifiers vs registry policy
    - install/init/add/install/update/publish flows
    - consumer workflows vs package author workflows vs registry operator workflows
4. Keep examples, warnings, operational caveats, and edge cases when they affect real usage.
5. When the question involves behavior changes over time, read `references/release-history-and-operational-notes.md` before answering confidently.

## Reference Map

- `references/overview-and-setup.md`
    - Product overview, installation, quickstart, root README context, and first-stop onboarding.
- `references/manifest-and-cli-reference.md`
    - `pesde.toml`, command reference, flags, command routing, and manifest field behavior.
- `references/dependencies-workspaces-and-overrides.md`
    - Dependency specifiers, workspaces, overrides, patching, and engine constraints.
- `references/package-types-and-targets.md`
    - Roblox usage, binary packages, scripts packages, target-specific behavior, and runtime tradeoffs.
- `references/publishing-and-registry-operations.md`
    - Publishing, yanking, deprecating, package docs, and maintainer-facing registry operations.
- `references/self-hosting-and-registry-policy.md`
    - Self-hosted registry setup, index configuration, auth/storage env vars, and registry policies.
- `references/release-history-and-operational-notes.md`
    - Changelog, security policy, compatibility context, and operational history.
- `references/index.md`
    - Human-readable map of the generated corpus and source coverage.

## Usage Notes

- For `pesde.toml` questions, start with `manifest-and-cli-reference.md`.
- For install or first-project help, combine `overview-and-setup.md` with `manifest-and-cli-reference.md`.
- For package-specifier and resolution questions, open `dependencies-workspaces-and-overrides.md`.
- For Roblox or runtime-target questions, read `package-types-and-targets.md` and keep target constraints explicit.
- For publish/yank/deprecate flows, combine `publishing-and-registry-operations.md` with `self-hosting-and-registry-policy.md` when policy matters.
- For private registries or operator workflows, start with `self-hosting-and-registry-policy.md`.
- For regressions, historical behavior, or upgrade-related doubts, check `release-history-and-operational-notes.md`.

## Resources

- `references/`
    - Topic-grouped documentation organized for fast lookup across practical `pesde` workflows.
