local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local jecs = require(ReplicatedStorage.pkg.jecs)
local world = require(ReplicatedStorage.world)

local player = world:component() :: jecs.Id<Player>
local profile_players_seeded = world:component() :: jecs.Id<boolean>
local needs_profile_load = world:component()
local profile_loading = world:component()
local profile_load_result = world:component() :: jecs.Id<unknown>
local profile = world:component() :: jecs.Id<unknown>
local needs_profile_unload = world:component()
local kick_reason = world:component() :: jecs.Id<string>

return table.freeze {
	Player = player,
	ProfilePlayersSeeded = profile_players_seeded,
	NeedsProfileLoad = needs_profile_load,
	ProfileLoading = profile_loading,
	ProfileLoadResult = profile_load_result,
	Profile = profile,
	NeedsProfileUnload = needs_profile_unload,
	KickReason = kick_reason,
}
