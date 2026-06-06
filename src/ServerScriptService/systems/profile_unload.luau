local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local ServerScriptService = game:GetService 'ServerScriptService'

local components = require(ReplicatedStorage.components)
local jecs_utils = require(ReplicatedStorage.pkg.jecs_utils)
local profile_store = require(ServerScriptService.profile_store)
local world = require(ReplicatedStorage.world)

type LoadedProfile = typeof(assert(
	profile_store:StartSessionAsync(`profile_key`, {})
))

local ref = jecs_utils.ref
local ProfileUnload =
	world:query(components.Player, components.NeedsProfileUnload):cached()

local function release_profile(entity, profile: LoadedProfile?)
	world:remove(entity, components.Profile)

	if not profile then return end
	if not profile:IsActive() then return end

	profile:EndSession()
end

local function delete_profile_entity(entity, player: Player)
	ref.delete(player)

	if not world:contains(entity) then return end

	world:delete(entity)
end

local function kick_player_if_needed(player: Player, kick_reason: string?)
	if not kick_reason or player.Parent ~= Players then return end

	player:Kick(kick_reason)
end

local function system()
	for entity, player in ProfileUnload do
		local kick_reason = world:get(entity, components.KickReason) :: string?
		local profile = world:get(entity, components.Profile) :: LoadedProfile?

		release_profile(entity, profile)
		delete_profile_entity(entity, player)
		kick_player_if_needed(player, kick_reason)
	end
end

return {
	name = 'Profile: Unload',
	system = system,
}
