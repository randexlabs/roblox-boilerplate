local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local ServerScriptService = game:GetService 'ServerScriptService'

local components = require(ReplicatedStorage.components)
local profile_store = require(ServerScriptService.profile_store)
local world = require(ReplicatedStorage.world)

type LoadedProfile = typeof(assert(
	profile_store:StartSessionAsync(`profile_key`, {})
))
type ProfileLoadResult =
	{ kind: 'success', profile: LoadedProfile }
	| { kind: 'failure', reason: string }

local profile_load = world
	:query(components.Player, components.NeedsProfileLoad)
	:without(components.Profile)
	:without(components.ProfileLoading)
	:cached()

local function start_session_async(player: Player)
	return profile_store:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})
end

local function write_profile_load_result(entity, result: ProfileLoadResult)
	world:set(entity, components.ProfileLoadResult, result)
end

local function end_session(profile: LoadedProfile)
	if not profile:IsActive() then return end

	profile:EndSession()
end

local function should_discard_profile(entity)
	if not world:contains(entity) then return true end
	if not world:has(entity, components.NeedsProfileUnload) then
		return false
	end

	return true
end

local function handle_profile_load_error(entity)
	if not world:contains(entity) then return end
	if world:has(entity, components.NeedsProfileUnload) then return end

	write_profile_load_result(entity, {
		kind = 'failure',
		reason = 'Profile load error - Please rejoin',
	})
end

local function load_profile(entity, player: Player)
	local ok, profile = pcall(start_session_async, player)

	if not ok then
		handle_profile_load_error(entity)
		return
	end

	local loaded_profile = profile :: LoadedProfile?

	if should_discard_profile(entity) then
		if not loaded_profile then return end

		end_session(loaded_profile)
		return
	end

	if not loaded_profile then
		write_profile_load_result(entity, {
			kind = 'failure',
			reason = 'Profile load fail - Please rejoin',
		})
		return
	end

	write_profile_load_result(entity, {
		kind = 'success',
		profile = loaded_profile,
	})
end

local function system()
	for entity, player in profile_load do
		world:remove(entity, components.NeedsProfileLoad)

		if world:has(entity, components.NeedsProfileUnload) then continue end

		world:add(entity, components.ProfileLoading)

		task.spawn(load_profile, entity, player)
	end
end

return {
	name = 'Profile: Load',
	system = system,
}
