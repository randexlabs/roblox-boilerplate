---
name: rojo-docs
description: Answer practical Rojo questions for Roblox projects using reorganized official Rojo documentation. Use when working with Rojo installation, project layout, sync behavior, filesystem-to-instance mapping, `default.project.json`, property syntax, migration, version differences, partially vs fully managed workflows, troubleshooting, or Rojo-related team workflows.
---

# Rojo Docs

Use this skill when the user needs source-based guidance about how Rojo works in practice.

Default to the current Rojo docs for behavior and syntax. Read the legacy references only when the user is dealing with older Rojo versions, historical migrations, or guidance that no longer appears in the latest docs.

## Workflow

1. Identify the question type before loading references.
2. Read only the reference files that match the task.
3. Prefer the latest/current behavior unless the repo or user explicitly targets Rojo 6 or older.
4. Preserve nuance when answering:
    - distinguish build behavior from live sync behavior
    - distinguish current guidance from legacy guidance
    - keep caveats, warnings, and migration notes

## Reference Map

- `references/overview-and-ecosystem.md`
    - What Rojo is for, why teams adopt it, editor/tooling ecosystem, version control context, TypeScript context, and support channels.
- `references/getting-started.md`
    - Installation, plugin setup, creating a new project, building, live sync, and upload/deployment basics.
- `references/project-structure-and-sync.md`
    - Filesystem mapping, script naming, models, localization tables, text/JSON/TOML modules, nested projects, and meta files.
- `references/project-format.md`
    - `*.project.json` schema, instance descriptions, property encoding rules, and example project layouts.
- `references/properties-overview.md`
    - Property support matrix and the practical meaning of build/live-sync/project-file coverage.
- `references/properties-reference.md`
    - Detailed property encoding formats and examples.
- `references/workflows-migration-and-alternatives.md`
    - Recommended workflows, partial vs full management, porting existing games, migration away from Rojo, and alternative tools.
- `references/versioning-and-history.md`
    - Rojo 6 to 7 upgrade notes, legacy v0.5 guidance that still helps explain tradeoffs, and project history/maintenance context.

## Usage Notes

- When answering project-mapping questions, combine `project-structure-and-sync.md` with `project-format.md`.
- When answering property questions, start with `properties-overview.md`, then open `properties-reference.md` for the exact encoding.
- When the user is troubleshooting sync limitations, read `project-structure-and-sync.md` and keep the distinction between live sync and build output explicit.
- When the user is deciding whether to adopt or expand Rojo, read `overview-and-ecosystem.md` plus `workflows-migration-and-alternatives.md`.
- When the user mentions old syntax, explicit `Type` / `Value` objects, or historical docs, read `versioning-and-history.md`.
