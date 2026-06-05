# Getting Started

## Placement and Runtime

ProfileStore is intended to run on the server. It should live in a server-available location and be required only by server code, because Roblox DataStores are server-side APIs.

## Standard Player Pattern

The standard flow is:

1. Create a store with a profile template.
2. Start a session when the player joins.
3. Add the player user ID for GDPR-oriented association.
4. Reconcile missing fields against the template if desired.
5. Release the session immediately when the player leaves.

```luau
local ProfileStore = require(game.ServerScriptService.ProfileStore)

local PROFILE_TEMPLATE = {
    Cash = 0,
    Items = {},
}

local Players = game:GetService("Players")

local PlayerStore = ProfileStore.New("PlayerStore", PROFILE_TEMPLATE)
local Profiles: {[Player]: typeof(PlayerStore:StartSessionAsync())} = {}

local function PlayerAdded(player)
    local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
        Cancel = function()
            return player.Parent ~= Players
        end,
    })

    if profile ~= nil then
        profile:AddUserId(player.UserId)
        profile:Reconcile()

        profile.OnSessionEnd:Connect(function()
            Profiles[player] = nil
            player:Kick(`Profile session end - Please rejoin`)
        end)

        if player.Parent == Players then
            Profiles[player] = profile
        else
            profile:EndSession()
        end
    else
        player:Kick(`Profile load fail - Please rejoin`)
    end
end

for _, player in Players:GetPlayers() do
    task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
    local profile = Profiles[player]
    if profile ~= nil then
        profile:EndSession()
    end
end)
```

## Template Use

The `template` passed to `ProfileStore.New()` is deep-copied only when a profile is created for the first time. If you later add new fields to the template, existing profiles only get those fields after `profile:Reconcile()`.

Only string-keyed template entries are reconciled. Nested tables are deep-copied recursively.

## Studio Testing

If Studio API services are disabled, ProfileStore falls back to a mock-like persistence path and data will not persist to live keys. If Studio API services are enabled, regular stores write to live DataStore keys. Use `ProfileStore.Mock` when you want to test logic without touching production-like data.

## First Rules To Enforce In Game Code

- Always call `profile:EndSession()` as soon as the profile is no longer needed.
- Never yield between checking `profile:IsActive()` and making critical changes.
- Treat a `nil` result from `:StartSessionAsync()` as a load failure and handle it decisively.
- Keep profile keys short and valid strings.
