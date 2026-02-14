local ReplicatedFirst = game:GetService('ReplicatedFirst')
local ServerScriptService = game:GetService('ServerScriptService')

local features = ServerScriptService.features
local loader = require(ReplicatedFirst.helpers.loader)

loader(features)
