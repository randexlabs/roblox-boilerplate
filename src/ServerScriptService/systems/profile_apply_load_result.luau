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
type ProfileLoadResult =
	{ kind: 'success', profile: LoadedProfile }
	| { kind: 'failure', reason: string }

local ref = jecs_utils.ref
local ProfileLoadResults =
	world:query(components.Player, components.ProfileLoadResult):cached()

local function queue_profile_unload(entity, reason: string?)
	world:add(entity, components.NeedsProfileUnload)

	if not reason then return end

	world:set(entity, components.KickReason, reason)
end

local function watch_profile_session(player: Player)
	return function()
		local tracked_entity = ref.find(player)
		if not tracked_entity or not world:contains(tracked_entity) then
			return
		end

		queue_profile_unload(
			tracked_entity,
			'Profile session end - Please rejoin'
		)
	end
end

local function handle_loaded_profile(
	entity,
	player: Player,
	profile: LoadedProfile
)
	if
		player.Parent ~= Players
		or world:has(entity, components.NeedsProfileUnload)
	then
		if profile:IsActive() then profile:EndSession() end

		queue_profile_unload(entity)
		return
	end

	if not profile:IsActive() then
		queue_profile_unload(entity, 'Profile session ended - Please rejoin')
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	profile.OnSessionEnd:Connect(watch_profile_session(player))

	world:set(entity, components.Profile, profile)
end

local function consume_profile_load_result(entity)
	world:remove(entity, components.ProfileLoadResult)

	if not world:has(entity, components.ProfileLoading) then return end

	world:remove(entity, components.ProfileLoading)
end

local function system()
	for entity, player, load_result in ProfileLoadResults do
		consume_profile_load_result(entity)

		local result = load_result :: ProfileLoadResult

		if result.kind == 'failure' then
			queue_profile_unload(entity, result.reason)
			continue
		end

		handle_loaded_profile(entity, player, result.profile)
	end
end

return {
	name = 'Profile: Apply Load Result',
	system = system,
}
