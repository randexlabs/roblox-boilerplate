---
name: profilestore
description: Practical reference for ProfileStore, a Roblox DataStore wrapper focused on profile sessions, autosaving, session locking, rollback queries, messaging, and player-data reliability. Use when Codex needs to answer questions about loading or releasing profiles, session conflict behavior, rollback workflows, developer product handling, mock stores, tuning constants, DataStore budgeting, or ProfileStore API caveats.
---

# ProfileStore

Use this skill for practical ProfileStore questions. Favor the implementation when documentation examples and runtime behavior differ.

## Quick Routing

- For what ProfileStore is, when it fits, and the core vocabulary, read [references/overview.md](references/overview.md).
- For installation, first-session setup, and the standard player-data pattern, read [references/getting-started.md](references/getting-started.md).
- For the mental model behind sessions, locks, autosaving, takeover, and message delivery, read [references/session-model.md](references/session-model.md).
- For request costs, limits, and constant tuning tradeoffs, read [references/request-costs-and-tuning.md](references/request-costs-and-tuning.md).
- For sharp edges, serialization failures, studio behavior, and slow-load diagnosis, read [references/troubleshooting.md](references/troubleshooting.md).
- For developer product receipt patterns, read [references/developer-products.md](references/developer-products.md).

## API References

- Module-level state and constructors: [references/apis/module.md](references/apis/module.md)
- `ProfileStore` instance API: [references/apis/store.md](references/apis/store.md)
- `Profile` API: [references/apis/profile.md](references/apis/profile.md)
- `VersionQuery` API: [references/apis/version-query.md](references/apis/version-query.md)

## Working Rules

- Treat ProfileStore as session-based persistence, not a generic global-state or leaderboard system.
- Distinguish active session access from read-only snapshot access via `:GetAsync()` and `:VersionQuery()`.
- Call out that `Profile:IsActive()` guarantees are only safe until the next yield.
- Preserve session-lock semantics in advice; `Steal = true` is for debugging or emergency flows, not normal player loads.
- Record doc/runtime mismatches explicitly, especially around mock mode, version-query support, and hidden or undocumented helpers.
