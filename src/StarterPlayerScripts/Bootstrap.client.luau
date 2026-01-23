local ReplicatedFirst = game:GetService('ReplicatedFirst')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Features = ReplicatedStorage.Client.Features
local Loader = require(ReplicatedFirst.Helpers.Loader)

Loader(Features)
