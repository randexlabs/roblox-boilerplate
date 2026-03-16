local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local ecs = require(ReplicatedStorage.pkg.ecs)
return ecs.world()
