local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local components = require(ReplicatedStorage.components)
local jecs_utils = require(ReplicatedStorage.pkg.jecs_utils)
local world = require(ReplicatedStorage.world)

local collect = jecs_utils.collect
local ref = jecs_utils.ref

local PlayerRemoving = collect(Players.PlayerRemoving)

local function queue_profile_unload(player: Player)
	local entity = ref.find(player)
	if not entity or not world:contains(entity) then return end

	world:add(entity, components.NeedsProfileUnload)
end

local function system()
	for _, player in PlayerRemoving do
		queue_profile_unload(player)
	end
end

return {
	name = 'Profile: Ingest Player Removing',
	system = system,
}
