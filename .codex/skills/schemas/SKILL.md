---
name: schemas
description: Project rules for schema modules in this Roblox codebase. Use when creating, reviewing, refactoring, or interpreting files under `ServerScriptService/Schemas`, canonical persistent data shapes, default data objects, or other project-local structural contracts that should stay separate from services and business logic.
---

# Schemas

Use this skill as the project-local specification for `Schemas` modules.

## Purpose

- Treat `Schemas` as the home for canonical structural contracts.
- Let each schema module represent one specific data shape.
- Let schemas answer "what is the shape of this data?" rather than "is this action valid right now?".
- Keep schemas separate from services, domain rules, UI behavior, and general-purpose utilities.

## What Belongs In Schemas

- Persistent profile data shapes.
- Canonical default data objects for a specific schema when the project needs one.
- Important internal request or payload shapes when a dedicated structural contract adds clarity.
- Schema-local type exports that make other modules depend on a shared shape intentionally.

Good examples:

- `PlayerProfileSchema`
- `InventoryProfileSchema`
- `QuestProgressSchema`
- `MatchSettingsSchema`

## What Does Not Belong In Schemas

- Domain behavior such as spending currency, equipping items, or completing quests.
- Service orchestration, lifecycle, event wiring, or async boundaries.
- Generic helper bags, utils, or validators with unrelated responsibilities.
- Error handling policies, UI reactions, logging decisions, or business-rule enforcement.
- Broad catch-all files that mix unrelated shapes under one vague name.

Bad examples:

- `CurrencySchema` containing `Spend`, `Grant`, or `CanAfford`
- `InventorySchema` containing equip or unequip logic
- `PlayerDataSchema` when the actual file only represents one specific persistent shape

## Naming

- Name each schema after one specific structural contract.
- Prefer names that describe the exact data being modeled, not a broad category around it.
- Use `PascalCase` names such as `PlayerProfileSchema`, not vague names such as `PlayerDataSchema` unless the scope is truly broad by design.
- If a schema only represents one persistent shape, make the filename and module name point directly at that shape.

## API Shape

- Keep schema APIs minimal.
- Prefer exporting the canonical data object directly when the module is only defining one default shape.
- Prefer a tiny, obvious surface over wrapper tables with redundant names.
- If the schema needs a separate default object entry point, keep the name short and structural, such as `Default`.
- Do not over-engineer schemas into mini frameworks.

Good:

```luau
export type PlayerProfileData = {
	Money: number,
}

local PlayerProfileSchema: PlayerProfileData = {
	Money = 0,
}

return table.freeze(PlayerProfileSchema)
```

## Relationship To Other Layers

- `Schemas` define structure.
- `Services` own domain operations and business rules.
- `Errors` own stable error code catalogs.
- `Result` standardizes public fallible API returns.

Use this split:

- If the main question is "what fields exist and what is the canonical shape?" use `Schemas`.
- If the main question is "can this action happen?" use a `Service`.
- If the main question is "how do we represent this failure?" use `Errors` and `Result`.
