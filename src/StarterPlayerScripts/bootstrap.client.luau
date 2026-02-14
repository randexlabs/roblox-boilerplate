local ReplicatedFirst = game:GetService('ReplicatedFirst')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local features = ReplicatedStorage.client.features
local loader = require(ReplicatedFirst.helpers.loader)

loader(features)
