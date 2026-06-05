# `VersionQuery` API

## Constructor Source

`VersionQuery` objects are created by `store:VersionQuery(...)`.

## Method

### `query:NextAsync() -> Profile?`

Yields and returns the next matching profile version as a snapshot `Profile`, or `nil` when no more results are available.

Behavior details:

- the first call may initialize `ListVersionsAsync()`
- later calls may advance result pages internally
- each returned profile is similar to one from `store:GetAsync()`
- returned profiles are not active sessions and can be written back with `profile:SetAsync()`

## Environment Caveats

- Unsupported in mock mode.
- Unsupported when `ProfileStore.DataStoreState` is not `"Access"`.
- In unsupported environments, it silently returns `nil` and may warn once in Studio.

## Rollback Pattern

Typical rollback flow:

1. create a descending query for the target key
2. optionally bound it by `max_date`
3. call `NextAsync()` until the desired snapshot is found
4. inspect `profile.Data`
5. call `profile:SetAsync()` only once you are sure you want to restore that snapshot

## Date Input Notes

The documented API accepts either `DateTime` or epoch milliseconds. When using human dates tied to a player report, remember timezone uncertainty. A rough UTC boundary may be good enough, but the result can be off by up to about a day if the timezone guess is wrong.
