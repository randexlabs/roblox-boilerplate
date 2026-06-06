---
name: moonwave
description: Answer practical Moonwave questions using reorganized local documentation and source-backed behavior notes. Use when working with Moonwave CLI commands, doc-comment tags, type syntax, moonwave.toml configuration, Docusaurus integration, publishing, custom pages, extractor JSON output, or Moonwave doc-generation troubleshooting.
---

# Moonwave

Use this skill for practical questions about `Moonwave`, the Lua/Luau documentation generator built around a CLI, a Rust extractor, and a Docusaurus plugin.

Favor the user-facing CLI and docs first, then use observed implementation behavior when the website docs are incomplete or stale.

## Quick Routing

- For what Moonwave is, how its pieces fit together, and what problems it solves, read [references/overview.md](references/overview.md).
- For installation, first-run workflow, project layout, and the fastest way to get a site running, read [references/getting-started.md](references/getting-started.md).
- For how Moonwave models classes, members, tags, homepage generation, API organization, and type-linking behavior, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For validation failures, missing output, publish issues, config pitfalls, and doc/runtime mismatches, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- CLI commands, flags, and build/dev behavior: [references/apis/cli.md](references/apis/cli.md)
- `moonwave.toml` keys, inferred defaults, and content-folder conventions: [references/apis/configuration.md](references/apis/configuration.md)
- Supported doc-comment tags, comment forms, and type syntax rules: [references/apis/tags-and-types.md](references/apis/tags-and-types.md)
- Extractor command, JSON output model, and Docusaurus plugin behavior: [references/apis/extractor-and-plugin.md](references/apis/extractor-and-plugin.md)

## Working Rules

- Treat Moonwave as three cooperating surfaces: the CLI prepares and runs the site, the extractor produces JSON from Lua/Luau comments, and the Docusaurus plugin renders that JSON.
- Be explicit that Moonwave "classes" are documentation containers, not a requirement for object-oriented runtime design.
- When explaining behavior, distinguish documented configuration from inferred defaults pulled from Git metadata or CLI code.
- Preserve validation details. Moonwave is strict about bad tag combinations, missing `@within`, and mismatched `@param` tags.
- Mention doc/runtime mismatches when relevant. In particular, the docs emphasize `moonwave.toml`, but the CLI also accepts `moonwave.json`.
- For advanced questions, treat the implementation as authoritative for CLI flags, config defaulting, sidebar behavior, and plugin restrictions.
