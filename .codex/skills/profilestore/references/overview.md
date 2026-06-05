# Overview

## What ProfileStore Is

ProfileStore is a single-module Roblox DataStore wrapper built around the idea of a profile session. A profile is the saved unit of data. A session is the temporary ownership of that profile by one server.

The library is designed for player-style persistence where each player usually maps to one key. Its main value is not just autosave convenience, but safe ownership transfer between servers through session locking. That is what prevents common duplication problems in trading or inventory-heavy games.

## Core Terms

| Term                    | Meaning                                                             |
| ----------------------- | ------------------------------------------------------------------- |
| `ProfileStore`          | Store object created with `ProfileStore.New(store_name, template?)` |
| profile                 | Saved payload stored under a single DataStore key                   |
| session                 | A server's active ownership of that key                             |
| `Profile.Data`          | Writable data table that autosaves while the session is active      |
| `Profile.LastSavedData` | Last snapshot confirmed written to the DataStore                    |
| `ProfileStore.Mock`     | Isolated fake store that never touches the live DataStore           |
| `VersionQuery`          | Cursor-like object for iterating historical key versions            |

## Good Fit

- Player progression data
- Inventories, currencies, unlocks, quest state
- Data that must not be written by multiple servers at once
- Systems that need rollback or read-only history inspection

## Bad Fit

- Global leaderboards
- Shared world state updated by many servers
- High-frequency cross-server writes to the same key
- Cases where session locking would be too conservative

The README is explicit that ProfileStore is not intended for leaderboards or other global state.

## Design Shape

ProfileStore wraps Roblox `DataStoreService` and also uses `MessagingService` to resolve session conflicts faster. When another server wants a locked profile, the current owner is asked to save and release it. If that does not happen quickly enough, the waiting server eventually steals the session after a timeout.

## Runtime State Flags

Module-level state exposes useful health information:

- `ProfileStore.IsClosing`: flips when shutdown begins; many operations then fail silently.
- `ProfileStore.IsCriticalState`: flips after too many recent DataStore failures.
- `ProfileStore.DataStoreState`: `"NotReady"`, `"NoInternet"`, `"NoAccess"`, or `"Access"`.

These flags are useful for analytics, player messaging, and graceful degradation during outages.
