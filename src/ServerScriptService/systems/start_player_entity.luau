local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local co = require(ReplicatedStorage.co)
local collect = require(ReplicatedStorage.collect)
local ecs = require(ReplicatedStorage.pkg.ecs)
local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local ref = require(ReplicatedStorage.ref)
local phases = planck_runservice.Phases
type World = ecs.World

local PlayerAdded = collect(Players.PlayerAdded)

local function system(world: World)
	local player = PlayerAdded()
	if not player then return end
	world:set(ref(player), co.player, player)
end

return {
	system = system,
	phase = phases.Update,
}
