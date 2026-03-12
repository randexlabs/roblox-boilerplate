local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local planck = require(ReplicatedStorage.pkg.planck)
local planck_jabby = require(ReplicatedStorage.pkg.planck_jabby)
local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local world = require(script.Parent.world)

return planck.Scheduler
	.new(world)
	:addPlugin(planck_runservice.Plugin.new())
	:addPlugin(planck_jabby.new())
