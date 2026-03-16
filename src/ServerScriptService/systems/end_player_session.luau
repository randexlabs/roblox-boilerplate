local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local co = require(ReplicatedStorage.co)
local collect = require(ReplicatedStorage.collect)
local ecs = require(ReplicatedStorage.pkg.ecs)
local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local ref = require(ReplicatedStorage.ref)
local phases = planck_runservice.Phases
type World = ecs.World

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
	phase = phases.PostUpdate,
}
