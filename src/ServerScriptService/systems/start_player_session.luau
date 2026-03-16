local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local co = require(ReplicatedStorage.co)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local ref = require(ReplicatedStorage.ref)
local world = require(ReplicatedStorage.world)
local phases = planck_runservice.Phases
type World = jecs.World

local store = assert(world:get(co.player_store, co.player_store))

local function start_session(player: Player)
	local profile = store:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if not profile then
		player:Kick(`Profile load fail - Please rejoin`)
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	profile.OnSessionEnd:Connect(function()
		player:Kick(`Profile session end - Please rejoin`)
	end)

	if player.Parent == Players then
		local e = ref(player)
		world:set(e, co.profile, profile)
		world:remove(e, co.profile_loading)
	else
		profile:EndSession()
	end
end

local function system(world: World)
	for _, player in Players:GetPlayers() do
		local e = ref(player)
		if world:get(e, co.profile) then continue end
		if world:get(e, co.profile_loading) then continue end

		world:set(e, co.player, player)
		world:set(e, co.profile_loading, true)
		task.spawn(start_session, player)
	end
end

return {
	system = system,
	phase = phases.First,
}
