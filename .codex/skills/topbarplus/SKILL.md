---
name: topbarplus
description: Practical reference for TopbarPlus, a Roblox topbar icon library for dynamic icons, themes, captions, dropdowns, menus, notices, toggle bindings, gamepad support, and overflow handling. Use when Codex needs to answer questions about constructing or styling icons, binding UI or hotkeys, composing menus and dropdowns, handling icon states and events, integrating NumberSpinner, or dealing with TopbarPlus runtime caveats and compatibility aliases.
---

# TopbarPlus

Use this skill for practical TopbarPlus questions. Prefer the runtime implementation when the docs and source differ.

## Quick Routing

- For what TopbarPlus is, where it fits, and the core model, read [references/overview.md](references/overview.md).
- For installation choices, placement, and first icon setup, read [references/getting-started.md](references/getting-started.md).
- For icon states, chaining, themes, and appearance rules, read [references/states-and-theming.md](references/states-and-theming.md).
- For dropdowns, menus, notices, captions, toggle items, and composition patterns, read [references/composition-and-features.md](references/composition-and-features.md).
- For gamepad behavior, overflow logic, multi-package runtime, and compatibility notes, read [references/platform-and-compatibility.md](references/platform-and-compatibility.md).
- For debugging odd behavior and source/doc mismatches, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Static module API: [references/apis/static.md](references/apis/static.md)
- Core `Icon` API: [references/apis/icon-core.md](references/apis/icon-core.md)
- Composition, events, and interaction API: [references/apis/icon-interaction.md](references/apis/icon-interaction.md)
- Runtime-only extensions and compatibility aliases: [references/apis/runtime-extensions.md](references/apis/runtime-extensions.md)

## Working Rules

- Treat TopbarPlus as a client-side topbar UI library; create icons from `LocalScript` context.
- Distinguish documented API from runtime-exposed compatibility helpers and soft-public extensions.
- Preserve `iconState` semantics: `Deselected`, `Selected`, and `Viewing` are not interchangeable.
- When discussing themes, prefer `modifyTheme` and `modifyBaseTheme` unless the question is explicitly about lower-level theme control.
- Call out multi-package deduplication behavior when third-party tools may also require TopbarPlus.
