local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local co = require(ReplicatedStorage.co)
local collect = require(ReplicatedStorage.collect)
local jecs = require(ReplicatedStorage.packages.jecs)
local planck_runservice = require(ReplicatedStorage.packages.planck_runservice)
local ref = require(ReplicatedStorage.ref)
local phases = planck_runservice.Phases
type World = jecs.World

local PlayerRemoving = collect(Players.PlayerRemoving)

local function system(world: World)
	local player = PlayerRemoving()
	if not player then return end

	local e = ref(player)
	local profile = world:get(e, co.profile)
	if not profile then return end

	world:remove(e, co.profile)

	if profile:IsActive() then profile:EndSession() end
	print(`Profile session ended - {player.Name}({player.UserId})`)
end

return {
	system = system,
	phase = phases.Last,
}
