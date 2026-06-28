# MonetizationService Test Plan

This document exists to preserve the intended test coverage for the current `MonetizationService` design.

The codebase does not have the full automated test setup yet, but these cases should be implemented when tests are introduced.

## Goal

Protect the core invariants of developer product receipt handling:

- the same receipt must not grant twice
- `PurchaseGranted` must only happen after durable confirmation
- `NotProcessedYet` must keep the flow retry-safe
- local in-session state and durable saved state must be treated differently

## Main Invariants

### Developer product receipts

- `PurchaseId` is the identity of one specific purchase.
- `ProductId` identifies the product type, not the purchase instance.
- A replay of the same `PurchaseId` must not reapply the grant.
- A new purchase of the same `ProductId` with a different `PurchaseId` must still grant normally.

### Session state vs durable state

- `profile.Data.ProcessedPurchaseIds[purchaseId]` means the purchase was already granted in the current session.
- `profile.LastSavedData.ProcessedPurchaseIds[purchaseId]` means the purchase was durably persisted.
- `PurchaseGranted` must depend on the durable state, not only on the current session state.

### Failure policy

- If profile loading fails, return `NotProcessedYet`.
- If the player leaves before the receipt flow is safe to continue, return `NotProcessedYet`.
- If product grant fails, return `NotProcessedYet`.
- If profile save fails or durable confirmation is missing, return `NotProcessedYet`.

## High Priority Test Cases

## 1. Grants once for a new receipt

Setup:

- player exists
- profile is loaded
- `PurchaseId` does not exist in `profile.Data`
- `PurchaseId` does not exist in `profile.LastSavedData`
- product callback succeeds
- save succeeds
- `PurchaseId` appears in `LastSavedData`

Expect:

- grant callback is called once
- `profile.Data.ProcessedPurchaseIds[purchaseId]` becomes `true`
- receipt returns `PurchaseGranted`

## 2. Does not grant again when receipt is already durably saved

Setup:

- player exists
- profile is loaded
- `PurchaseId` already exists in `profile.LastSavedData`

Expect:

- grant callback is not called
- save is not required
- receipt returns `PurchaseGranted`

## 3. Does not grant again when receipt was already granted in the current session

Setup:

- player exists
- profile is loaded
- `PurchaseId` exists in `profile.Data`
- `PurchaseId` does not yet exist in `profile.LastSavedData`
- save later succeeds

Expect:

- grant callback is not called again
- receipt only attempts persistence
- receipt returns `PurchaseGranted` only after durable confirmation

## 4. Returns `NotProcessedYet` when player is missing

Setup:

- `Players:GetPlayerByUserId` returns `nil`

Expect:

- no grant
- no save
- receipt returns failure result that maps to `NotProcessedYet`

## 5. Returns `NotProcessedYet` when profile load fails

Setup:

- player exists
- `ProfileStoreService.WaitForProfileAsync` returns failure

Expect:

- no grant
- no save
- receipt returns failure result that maps to `NotProcessedYet`

## 6. Returns `NotProcessedYet` when player leaves after profile wait yield

Setup:

- player exists before `WaitForProfileAsync`
- profile load succeeds
- player is no longer in `Players` after the wait

Expect:

- no grant
- no save
- receipt returns failure result that maps to `NotProcessedYet`

## 7. Returns `NotProcessedYet` when product definition is missing

Setup:

- player exists
- profile is loaded
- `PurchaseId` is not already granted
- no product exists for `ProductId`

Expect:

- no grant
- no save
- receipt returns failure result that maps to `NotProcessedYet`

## 8. Returns `NotProcessedYet` when grant callback fails

Setup:

- player exists
- profile is loaded
- product callback returns failure

Expect:

- `PurchaseId` is not marked as granted
- receipt returns failure result that maps to `NotProcessedYet`

## 9. Returns `NotProcessedYet` when save fails after grant

Setup:

- player exists
- profile is loaded
- product callback succeeds
- `PurchaseId` is marked in `profile.Data`
- `ProfileStoreService.SaveProfileAsync` returns failure

Expect:

- grant callback ran once
- receipt returns failure result that maps to `NotProcessedYet`
- replay of the same receipt in the same session must not regrant

## 10. Returns `NotProcessedYet` when save reports success but `LastSavedData` still lacks the `PurchaseId`

Setup:

- player exists
- profile is loaded
- product callback succeeds
- `SaveProfileAsync` returns success
- `profile.LastSavedData.ProcessedPurchaseIds[purchaseId]` is still missing

Expect:

- receipt returns failure result that maps to `NotProcessedYet`

This protects the invariant:

- save attempt is not enough
- durable confirmation is required

## 11. Allows two valid purchases of the same product

Setup:

- first receipt uses `PurchaseId = A`
- second receipt uses `PurchaseId = B`
- both have the same `ProductId`

Expect:

- both receipts grant successfully
- both purchases are recorded independently

This protects against the wrong design:

- deduplicating by `ProductId` instead of `PurchaseId`

## Useful Test Doubles

When tests are added, the most useful fakes or spies will likely be:

- fake `Players:GetPlayerByUserId`
- fake `ProfileStoreService.WaitForProfileAsync`
- fake `ProfileStoreService.SaveProfileAsync`
- fake product callback
- fake profile object with:
    - `Data`
    - `LastSavedData`
    - `IsActive()`
    - `OnAfterSave`

## Good Future Test Structure

Prefer small focused tests grouped by behavior:

- `describe("DeveloperProducts.HandleReceiptAsync", ...)`
- `describe("receipt replay handling", ...)`
- `describe("durable confirmation rules", ...)`

Avoid one giant integration-style test that hides which invariant failed.

## Regression Traps To Keep Covered

If the service is refactored later, do not lose tests for:

- replay in the same session
- replay after `NotProcessedYet`
- player leaving after yield
- distinction between `Data` and `LastSavedData`
- same `ProductId` with different `PurchaseId` values

## Minimal First Test Batch

If only a small first batch is written, prioritize these:

1. grants once for a new receipt
2. does not regrant when `PurchaseId` is already in `LastSavedData`
3. does not regrant when `PurchaseId` is already in `Data` in the same session
4. returns `NotProcessedYet` when save fails after grant
5. allows two different `PurchaseId` values for the same `ProductId`
