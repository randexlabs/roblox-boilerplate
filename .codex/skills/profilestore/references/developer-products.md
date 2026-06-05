# Developer Products

ProfileStore documentation preserves two receipt-handling patterns.

## Pattern 1: Official-Style Receipt Handling

The simpler pattern mirrors Roblox's standard `MarketplaceService.ProcessReceipt` flow:

- look up the player's active profile
- grant the product
- call `profile:Save()` for purchases that change persistent data
- return `PurchaseGranted` on success
- return `NotProcessedYet` if the profile is unavailable or the handler fails

This is adequate for many games, especially when the purchase effect is immediate and not catastrophically expensive to retry.

## Pattern 2: Cache `PurchaseId` For Stronger Safety

The stronger pattern stores processed `PurchaseId` values inside `Profile.Data`, grants the reward once, and waits until the ID appears in `Profile.LastSavedData` before returning `PurchaseGranted`.

This reduces the risk window where:

1. reward was granted in memory
2. DataStore save had not yet been confirmed
3. server crashes before persistence finishes

That pattern trades simplicity for stronger durability under rare outage-or-crash timing.

## Practical Guidance

- If the reward is persistent currency, inventory, or perks, prefer the cached `PurchaseId` pattern.
- If the reward is temporary or server-local, the simpler official-style pattern may be enough.
- In either pattern, do not assume the profile is instantly available when `ProcessReceipt` fires. Wait for the active profile if the player just joined.

## Useful Signals

- `Profile.LastSavedData` is the safety checkpoint for durable confirmation.
- `Profile.OnAfterSave` is a good wait point when forcing a purchase-related save cycle.
