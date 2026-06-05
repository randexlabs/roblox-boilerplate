# Troubleshooting

## Studio Data Does Not Persist

If Studio API services are disabled, ProfileStore will not persist to live DataStore keys. That is expected.

If Studio API services are enabled, regular stores do write to live keys. Use `ProfileStore.Mock` when you want isolated testing data instead.

## DataStore Cannot Serialize `Profile.Data`

ProfileStore does not proactively validate every value you put in `Profile.Data`. Common invalid payload shapes include:

- `NaN` values
- non-string and non-number table keys
- mixed array and dictionary keys in the same table
- sparse numeric arrays with gaps
- cyclic tables
- userdata, including `Instance`, `Vector3`, `CFrame`, `Udim2`, and similar Roblox datatypes
- functions

These are DataStore limitations, not ProfileStore-specific quirks. If present, saves can fail.

## Profiles Load Too Slowly

The docs treat profile loads slower than roughly 5 seconds as suspicious.

Likely causes:

- outdated ProfileStore version
- forgetting `Profile:EndSession()`
- releasing sessions too late after `Players.PlayerRemoving`
- errors inside your `PlayerRemoving` cleanup path
- a player joining a new server before the previous server released the profile

Useful probe:

```luau
profile.OnSessionEnd:Connect(function()
    print(`Profile session has ended ({profile.Key})`)
end)
```

## `StartSessionAsync()` Returns `nil`

Possible causes:

- shutdown started and `ProfileStore.IsClosing` is true
- your `Cancel` callback returned true
- default start timeout elapsed
- a very rare race occurred while another server tried to acquire the same profile

The docs recommend kicking and asking the player to rejoin if a real player profile fails to load.

## Metadata Is Tiny

`Profile.RobloxMetaData` uses Roblox key metadata limits, which are very small. The docs call out a roughly 300-character limit for total metadata content at the time of writing. Treat this as a tiny side channel, not a second save payload.

## Mock Mode Caveats

- `ProfileStore.Mock` is isolated from the live store even when using the same key names.
- If DataStore access is unavailable, regular store access still uses a separate internal mock path from `ProfileStore.Mock`.
- Version queries are effectively unsupported outside live-access mode; `VersionQuery:NextAsync()` returns `nil` in mock or no-access states.

## Doc And Runtime Mismatches Worth Remembering

- The source contains an undocumented `ProfileStore.Test()` helper. It is not part of the documented public surface and should not be treated as stable API.
- `Profile:SetAsync()` is for profiles loaded through `:GetAsync()` or `:VersionQuery()`, not active session profiles.
- `Profile.OnLastSave` may never fire if the server crashes abruptly. Do not make business-critical logic depend solely on that event.
