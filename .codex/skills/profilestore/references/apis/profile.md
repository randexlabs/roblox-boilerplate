# `Profile` API

## Core Data

### `profile.Data: table`

Writable data payload. During an active session, changes are guaranteed to be saved only while the profile remains active and your code has not yielded since the activity check.

You may replace `profile.Data` with a different table reference, but it must still be DataStore-serializable.

### `profile.LastSavedData: table`

Read-only snapshot of the last successfully persisted payload. This is the correct reference for "has this definitely been saved yet?" logic.

### `profile.FirstSessionTime: number`

Unix timestamp of the profile's first session creation time.

### `profile.SessionLoadCount: number`

How many times a session has been started for this profile.

### `profile.Session: {PlaceId: number, JobId: string}?`

Read-only description of the active owner at the time this profile object was created.

For a session-started profile, this is the owning server. For a snapshot loaded through `:GetAsync()`, it may be `nil` or another server's owner info.

### `profile.RobloxMetaData: table`

Writable metadata saved through Roblox key metadata, not through the main data payload.

Caveat: metadata size limits are very small.

### `profile.UserIds: {number}`

Read-only list of associated user IDs.

### `profile.KeyInfo: DataStoreKeyInfo`

Roblox key info object associated with this profile.

### `profile.ProfileStore: ProfileStore`

Reference back to the owning store object.

### `profile.Key: string`

The DataStore key for this profile.

## Signals

### `profile.OnSave`

Fires right before a save attempt writes `Profile.Data`.

Safe use:

- last-moment synchronous updates
- analytics hooks

Unsafe use:

- anything that yields and assumes the session remains active afterward

### `profile.OnLastSave`

Fires right before the final save of an active session with reason:

- `"Manual"`: `profile:EndSession()` called
- `"Shutdown"`: server shutdown
- `"External"`: another server took over

Important caveat: abrupt server crashes may prevent this event from firing at all.

### `profile.OnSessionEnd`

Fires when the active session ends on this server.

Use it to stop using the profile and detach gameplay state. Do not treat it as the place to apply final profile mutations; use `OnLastSave` for that case when possible.

### `profile.OnAfterSave`

Fires after a successful save and passes `last_saved_data`.

After this fires, `profile.LastSavedData` and `profile.KeyInfo` have been updated to the latest saved state.

This is useful when code must wait for durable persistence, such as purchase confirmation flows.

## Methods

### `profile:IsActive() -> boolean`

Returns whether the profile still has an active session owned by this server.

The guarantee expires on yield. The safe pattern is:

```luau
if profile:IsActive() then
    profile.Data.Cash += 100
end
```

Do not do a `task.wait()` between the check and the write if the write must be guaranteed.

### `profile:Reconcile()`

Fills in missing string-keyed fields from the store template. Existing values are preserved. Nested tables are reconciled recursively.

### `profile:EndSession()`

Ends the active session and triggers final persistence/release behavior. This is mandatory cleanup for session-started profiles.

### `profile:AddUserId(user_id: number)`

Associates a user ID with the profile for GDPR-related data ownership tracking.

### `profile:RemoveUserId(user_id: number)`

Removes a user ID association safely.

### `profile:MessageHandler(fn: (message: table, processed: () -> ()) -> ())`

Registers a handler for queued messages created by `store:MessageAsync()`.

Processing rule:

- call `processed()` when that handler has consumed the message
- if you do not call it, later handlers may also receive the same unprocessed message
- unprocessed messages continue to be offered again in later sessions

### `profile:Save()`

For active session profiles, immediately performs a save if the session is still active. This also resets the autosave timing.

Calling `Save()` on an inactive profile only warns and does not restore ownership.

### `profile:SetAsync()`

Forcefully writes a snapshot profile back to the DataStore.

This is intended only for profiles loaded with:

- `store:GetAsync()`
- `store:VersionQuery(...):NextAsync()`

It is the write path used for rollback-style workflows.
