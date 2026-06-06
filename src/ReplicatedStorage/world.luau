local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local jecs = require(ReplicatedStorage.pkg.jecs)
local jecs_utils = require(ReplicatedStorage.pkg.jecs_utils)
local world = jecs.world()

jecs_utils.world(world)

return world
