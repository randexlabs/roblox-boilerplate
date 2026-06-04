---
name: conch
description: Practical reference for Conch, a Roblox developer console and command language, including runtime command registration, permissions, custom argument types, UI mounting and hotkeys, standalone usage, autocomplete and analysis data, AST parsing and visiting, and plugin-facing history APIs. Use when Codex needs to answer questions about Conch packages, write or debug Conch commands, explain Conch syntax or built-in types, integrate custom argument analyzers, inspect runtime caveats, or work against the language and plugin APIs instead of generic Roblox console patterns.
---

# Conch

Use this skill as a navigation layer over the bundled Conch references. Keep answers source-backed and prefer the smallest relevant file set.

## Quick Routing

- For package scope, entry points, and which package to use, read [references/overview.md](references/overview.md).
- For setup, permissions, and command authoring, read [references/getting-started.md](references/getting-started.md), [references/permissions.md](references/permissions.md), and [references/types-and-command-authoring.md](references/types-and-command-authoring.md).
- For the command language itself, read [references/language-syntax.md](references/language-syntax.md).
- For caveats, mismatches between docs and runtime, and debugging guidance, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Runtime console API: [references/apis/runtime.md](references/apis/runtime.md)
- Argument builders and type helpers: [references/apis/args.md](references/apis/args.md)
- UI package API: [references/apis/ui.md](references/apis/ui.md)
- Language VM API: [references/apis/language.md](references/apis/language.md)
- Analysis and autocomplete shapes: [references/apis/analysis.md](references/apis/analysis.md)
- AST parser, visitor, and display API: [references/apis/ast.md](references/apis/ast.md)
- Plugin-facing APIs: [references/apis/plugin-api.md](references/apis/plugin-api.md)
- Standalone bundle API: [references/apis/standalone.md](references/apis/standalone.md)

## Working Rules

- Treat the runtime implementation as authoritative when docs, examples, and typings disagree.
- Call out mismatches explicitly. Conch has several stale names and partially undocumented exports.
- Distinguish stable user-facing APIs from low-level or underscored exports, but do not omit exported surfaces just because they look internal.
- Preserve practical context. Do not reduce answers to raw signatures when the caveat or execution model is the important part.
- Ignore repository-operational material unless the user explicitly asks about packaging or release flow.
