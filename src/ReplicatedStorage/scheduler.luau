local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local planck = require(ReplicatedStorage.packages.planck)
local planck_jabby = require(ReplicatedStorage.packages.planck_jabby)
local planck_runservice = require(ReplicatedStorage.packages.planck_runservice)
local world = require(script.Parent.world)

return planck.Scheduler
	.new(world)
	:addPlugin(planck_runservice.Plugin.new())
	:addPlugin(planck_jabby.new())
