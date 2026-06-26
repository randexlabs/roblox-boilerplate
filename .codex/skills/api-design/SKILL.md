---
name: api-design
description: Project rules for API design in this Roblox codebase. Use when designing, reviewing, refactoring, or implementing public module, service, or library APIs so the final interface is obvious to call, Roblox-like, intention-revealing, and protective of domain invariants.
---

# API Design Rules

You are not only writing code. You are creating an API that another programmer, another AI, or the project owner will use later.

## Core Rule

Do not start from implementation details.

Design the public API first and check whether it:

- expresses intent clearly
- protects business rules and invariants
- avoids anemic getters and setters
- feels obvious to call correctly

If the usage looks awkward, the implementation direction is probably wrong too.

## 1. Make the API feel obvious to use

Before implementing, think:

- how would someone call this?
- which names make usage self-explanatory?
- which mistakes can the API design prevent?

A good API reduces doubt.

Bad:

```luau
Inventory.Do(player, item, 2, true)
```

Good:

```luau
InventoryService.AddItem(player, itemId, amount)
InventoryService.RemoveItem(player, itemId, amount)
InventoryService.HasItem(player, itemId)
```

## 2. Prefer Roblox-like naming

Prefer naming patterns close to the engine:

- use `*Service` for global singleton services such as `InventoryService` or `QuestService`
- prefer verbal method names such as `Add`, `Remove`, `Create`, `Destroy`, `Find`, `Has`, `Is`, `Can`, `Grant`, `Spend`, `Unlock`, and `Complete`
- name events after facts that happened, such as `ItemAdded`, `QuestCompleted`, or `StageUnlocked`
- name booleans like questions, such as `CanAfford`, `IsUnlocked`, or `HasPet`

Be careful with `Get` and `Set`.

`Get` is acceptable for simple reads:

```luau
InventoryService.GetAmount(player, itemId)
StageService.GetCurrentStage(player)
```

`Set` is usually a smell because it often lets the caller bypass domain rules.

Avoid generic names such as:

- `Manager`
- `Handler`
- `Controller`
- `Util`
- `Data`

Use them only when there is a strong architectural reason.

## 3. Separate intent from implementation

The API should describe what happens, not how it happens.

Bad:

```luau
PetService.InsertPetIntoProfileAndReplicate(player, pet)
```

Good:

```luau
PetService.AddPet(player, petData)
```

The implementation may save, replicate, update UI, emit events, or do other internal work. The caller should not need to know that.

## 4. Keep inputs explicit

Do not rely on magical positional parameters when intent gets blurry.

Bad:

```luau
EggService.Hatch(player, "Naruto", true, 6, false)
```

Good:

```luau
EggService.Hatch(player, {
	EggId = "Naruto",
	Amount = 6,
	UseBoosts = true,
})
```

Use a request table when the operation has many arguments, flags, or optional settings.

## 5. Avoid exposing internal details

Keep internal helpers private and local.

A public API should stay small. Good design is not many functions. Good design is the right few functions.

## 6. Protect invariants through the API

Do not let the caller perform invalid state changes directly.

Bad:

```luau
Profile.Coins -= price
PetInventory[#PetInventory + 1] = pet
```

Good:

```luau
local canSpend = CurrencyService.CanAfford(player, "Coins", price)

if canSpend then
	CurrencyService.Spend(player, "Coins", price)
	PetService.AddPet(player, pet)
end
```

The module that knows the rule should control the rule.

## 7. Avoid automatic getters and setters

Getter and setter APIs often become anemic:

```luau
PetService.GetPets(player)
PetService.SetPets(player, pets)

CurrencyService.GetCoins(player)
CurrencyService.SetCoins(player, coins)
```

This usually spreads business logic outward and lets callers rebuild state unsafely.

Prefer intention-revealing APIs:

```luau
CurrencyService.CanAfford(player, "Coins", price)
CurrencyService.Spend(player, "Coins", price)
CurrencyService.Grant(player, "Coins", amount)

PetService.AddPet(player, petData)
PetService.RemovePet(player, petId)
PetService.EquipPet(player, petId)
PetService.UnequipPet(player, petId)
PetService.GetEquippedPets(player)
```

`Get` is acceptable for read-only queries that do not leak mutable internal state.

`Set` should exist only when it represents a clear and safe intent:

```luau
SettingsService.SetMusicEnabled(player, enabled)
```

Even then, prefer more specific names when they communicate better:

```luau
SettingsService.EnableMusic(player)
SettingsService.DisableMusic(player)
```

## 8. Do not make the caller assemble internal state

Bad:

```luau
InventoryService.SetInventory(player, newInventory)
```

Good:

```luau
InventoryService.AddItem(player, itemId, amount)
InventoryService.RemoveItem(player, itemId, amount)
InventoryService.Clear(player)
```

Avoid large setters that let callers bypass invariants.

## 9. Use events for facts, not commands

An event should describe something that already happened.

Good:

- `PetAdded`
- `CoinsChanged`
- `StageUnlocked`

Bad:

- `AddPetEvent`
- `UnlockStageEvent`

A command is a method. An event is a consequence.

## 10. Design before coding

Before implementing a module, write the expected public API first:

```luau
EggService.Hatch(player, request)
EggService.CanHatch(player, eggId, amount)
EggService.GetEggConfig(eggId)
EggService.Hatched:Connect(function(player, result) end)
```

Then implement it.

If the API feels strange in use, the implementation will probably become strange too.
