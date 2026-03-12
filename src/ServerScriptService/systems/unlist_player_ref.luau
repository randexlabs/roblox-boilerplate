local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local collect = require(ReplicatedStorage.collect)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local ref = require(ReplicatedStorage.ref)
local phases = planck_runservice.Phases
type World = jecs.World

local PlayerRemoving = collect(Players.PlayerRemoving)

local function system(world: World)
	local player = PlayerRemoving()
	if not player then return end
	ref.unlist(player)
end

return {
	system = system,
	phase = phases.Last,
}
