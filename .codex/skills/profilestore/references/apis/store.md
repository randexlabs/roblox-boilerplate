# `ProfileStore` Instance API

## Properties

### `store.Name: string`

Read-only store name passed to `ProfileStore.New()`.

### `store.Mock: ProfileStore`

Mirror object whose methods operate on an isolated fake DataStore.

Use cases:

- testing without touching live keys
- forcing isolated behavior in Studio even when API services are enabled

Important caveats:

- mock and live stores are isolated even for identical keys
- no-access fallback for the regular store is separate from `store.Mock`

## Methods

### `store:StartSessionAsync(profile_key: string, params?: { Cancel: (() -> boolean)?, Steal: boolean? }) -> Profile?`

Starts active ownership of a profile.

Behavior:

- yields until success, cancellation, shutdown, timeout, or rare acquisition race
- creates a new profile from the template if the key does not exist
- autosave starts once the session is active
- active session conflicts are resolved through retries and `MessagingService`

Rules:

- always call `profile:EndSession()` when done
- if you pass `Cancel`, you own the cancellation policy
- `Steal = true` bypasses normal lock safety

Validation:

- `profile_key` must be a non-empty string
- implementation rejects keys longer than 50 characters

### `store:MessageAsync(profile_key: string, message: table) -> boolean`

Persists a message into the target profile's queue and nudges the active owner to process it sooner.

Use it for critical messages that must survive server transitions, such as durable gifting flows. It is not a cheap replacement for transient `MessagingService`.

Validation:

- `profile_key` must be a non-empty string with length at most 50
- `message` must be a table

### `store:GetAsync(profile_key: string, version?: string) -> Profile?`

Loads a profile snapshot without starting a session.

Returned profile traits:

- no autosave
- no need to call `:EndSession()`
- can be edited and then written with `profile:SetAsync()`
- `profile.view_mode` is set internally

If the key has never been saved, returns `nil`.

Version notes:

- version lookup is only supported with live DataStore access
- in mock or no-access mode, providing `version` returns `nil`

### `store:VersionQuery(profile_key: string, sort_direction?: Enum.SortDirection, min_date?: DateTime | number, max_date?: DateTime | number) -> VersionQuery`

Builds an iterator over saved versions for a key.

Accepted date forms:

- `DateTime`
- epoch milliseconds as `number`

Typical uses:

- rollback investigation
- recovering a snapshot from before an incident
- studying how a profile changed over time

### `store:RemoveAsync(profile_key: string) -> boolean`

Deletes the stored key.

Use carefully. The docs frame this as destructive and unrecoverable. For live session-backed data, ensure the profile is no longer in use before removal.
