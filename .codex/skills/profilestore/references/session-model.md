# Session Model

## Why Sessions Exist

ProfileStore does not treat a saved key as something every server may edit freely. Instead, one server starts a session and becomes the active owner of that profile. While the session is active, writes to `Profile.Data` are guaranteed to be saved, subject to the usual caveat that the guarantee only holds until your code yields.

This is the core anti-dupe mechanism.

## Active Session Lifecycle

Typical lifecycle:

1. Server calls `ProfileStore:StartSessionAsync(key)`.
2. ProfileStore loads or creates the profile and records the active session owner.
3. The server mutates `Profile.Data` over time.
4. Autosave runs periodically.
5. Server calls `Profile:EndSession()` or shutdown triggers final save and release.

## Session Conflict Resolution

If another server wants the same key:

1. The waiting server detects the existing session.
2. It uses `MessagingService` to ask the current owner to finish and release.
3. It retries after a short delay.
4. If the session still does not release in time, ownership is eventually stolen.

The documented default timing is:

| Constant                | Default       | Meaning                                             |
| ----------------------- | ------------- | --------------------------------------------------- |
| `FIRST_LOAD_REPEAT`     | `5` seconds   | Delay between first and second retry after conflict |
| `LOAD_REPEAT_PERIOD`    | `10` seconds  | Retry interval during conflict                      |
| `SESSION_STEAL`         | `40` seconds  | Approximate time before forced takeover             |
| `ASSUME_DEAD`           | `630` seconds | Assume stale session belongs to a dead server       |
| `START_SESSION_TIMEOUT` | `120` seconds | Stop retrying if default timeout is in effect       |

## Cancellation Model

`StartSessionAsync` accepts `params.Cancel`, a callback that ProfileStore polls repeatedly. If it returns `true`, the request stops and returns `nil`.

This is primarily for cases like:

- player leaves before the profile finishes loading
- DataStore outages cause long retry loops
- the caller has a more specific cancellation condition than the default timeout

Important: supplying `Cancel` disables the default session-start timeout. Your callback then becomes the main escape hatch.

## Stealing

`params.Steal = true` bypasses the normal grace period and lets the new server take the session immediately. This exists for debugging or controlled emergency recovery, not normal player loading. Using it casually defeats the protection session locking is supposed to provide.

## Read-Only Access Versus Session Ownership

`ProfileStore:GetAsync()` and `ProfileStore:VersionQuery()` produce profile objects without starting an active session. These objects are for reading or constructing a payload to write back with `Profile:SetAsync()`. They do not autosave and do not need `:EndSession()`.

## Message Delivery Model

`ProfileStore:MessageAsync(key, message)` stores a message in the profile's update queue and nudges the active session owner to save and process it sooner. Messages are persistent in the profile payload, not transient pub-sub messages. They are intended for critical cross-server data handoff, not cheap best-effort signaling.
