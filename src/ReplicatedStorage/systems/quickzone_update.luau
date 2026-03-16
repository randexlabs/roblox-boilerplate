local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local ecs = require(ReplicatedStorage.pkg.ecs)
local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local quickzone = require(ReplicatedStorage.pkg.quickzone)
local scheduler = require(ReplicatedStorage.scheduler)
local phases = planck_runservice.Phases
type World = ecs.World

local function system(world: World)
	quickzone:update(scheduler:getDeltaTime())
end

return {
	system = system,
	phase = phases.PreUpdate,
}
