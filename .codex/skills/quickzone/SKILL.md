---
name: quickzone
description: Practical reference for QuickZone, a high-performance physics-free spatial query library for Roblox. Use when Codex needs to answer questions about QuickZone's runtime API, groups, zones, zone collections, observers, point-based detection model, scheduler and frame budget behavior, dynamic versus static zones, manual stepping, player tracking, or the library's public types and caveats.
---

# QuickZone

Use this skill as the entry point for QuickZone questions. Favor the runtime implementation when docs, examples, and typings disagree.

## Quick Routing

- For what QuickZone is, what problems it solves, and how the architecture fits together, read [references/overview.md](references/overview.md).
- For setup, first use, and recommended usage styles, read [references/getting-started.md](references/getting-started.md).
- For the mental model behind Groups, Zones, Observers, transitions, and priorities, read [references/architecture-and-patterns.md](references/architecture-and-patterns.md).
- For performance, scheduler behavior, point-based detection, and tuning tradeoffs, read [references/performance-and-behavior.md](references/performance-and-behavior.md).
- For mismatches, sharp edges, and debugging guidance, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Root runtime API: [references/apis/runtime.md](references/apis/runtime.md)
- `Zone` API: [references/apis/zone.md](references/apis/zone.md)
- `Zones` collection API: [references/apis/zones.md](references/apis/zones.md)
- `Group` API: [references/apis/group.md](references/apis/group.md)
- `Observer` API: [references/apis/observer.md](references/apis/observer.md)
- Public types and config defaults: [references/apis/types-and-config.md](references/apis/types-and-config.md)

## Working Rules

- Treat QuickZone as point-based detection, not full-volume collision testing.
- Distinguish the three supported usage styles: lifecycle, event-driven, and polling.
- Call out client-only APIs and safety-related callback behavior explicitly.
- Record naming or signature drift between `index.d.ts`, source docs, and runtime methods instead of flattening them away.
- Ignore repository-maintenance details unless the user explicitly asks for them.
