local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local components = require(ReplicatedStorage.components)
local jecs_utils = require(ReplicatedStorage.pkg.jecs_utils)
local world = require(ReplicatedStorage.world)

local ref = jecs_utils.ref

local function queue_profile_load(entity)
	if world:has(entity, components.Profile) then return end
	if world:has(entity, components.ProfileLoading) then return end
	if world:has(entity, components.NeedsProfileUnload) then return end

	world:add(entity, components.NeedsProfileLoad)
end

local function ingest_player(player: Player)
	local entity = ref(player, function(new_entity)
		world:set(new_entity, components.Player, player)
	end)

	queue_profile_load(entity)
end

local function system()
	local did_seed_players = world:get(
		components.ProfilePlayersSeeded,
		components.ProfilePlayersSeeded
	)

	if did_seed_players then return end

	world:set(
		components.ProfilePlayersSeeded,
		components.ProfilePlayersSeeded,
		true
	)

	for _, player in Players:GetPlayers() do
		ingest_player(player)
	end
end

return {
	name = 'Profile: Seed Players',
	system = system,
}
