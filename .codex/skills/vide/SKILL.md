---
name: vide
description: Answer practical Vide questions using reorganized documentation and runtime behavior notes. Use when working with Vide's reactive model, scopes, sources, derived values, UI creation, dynamic control flow, actions, context, springs, strict mode, runtime stepping, or documented-versus-implemented API differences.
---

# Vide

Use this skill as the entry point for practical Vide work. Favor the exported runtime behavior when tutorials, API docs, and implementation disagree.

## Quick Routing

- For what Vide is, how it thinks about reactivity, and which APIs are public, read [references/overview.md](references/overview.md).
- For setup, first-use patterns, and the usual component workflow, read [references/getting-started.md](references/getting-started.md).
- For the mental model behind stable scopes, reactive scopes, cleanup, implicit effects, and dynamic scopes, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For mismatches, sharp edges, and debugging guidance, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Core reactivity and control-flow APIs: [references/apis/reactivity.md](references/apis/reactivity.md)
- UI construction, mounting, property semantics, and actions: [references/apis/ui-creation.md](references/apis/ui-creation.md)
- Runtime helpers such as `spring()`, `step()`, and version metadata: [references/apis/runtime.md](references/apis/runtime.md)
- Global flags and public type aliases: [references/apis/flags-and-types.md](references/apis/flags-and-types.md)

## Working Rules

- Treat stable and reactive scopes as the core design constraint. Most Vide bugs reduce to scope ownership, reruns, or cleanup timing.
- Call out when a helper returns a source versus a plain value. Some published type snippets lag behind runtime behavior.
- Preserve documented-versus-implemented differences instead of flattening them away, especially for `create()`, dynamic control-flow helpers, and global flags.
- Mention delayed destruction behavior explicitly when discussing `show()`, `switch()`, `indexes()`, or `values()`.
- Ignore repository-maintenance details unless the user explicitly asks for them.
