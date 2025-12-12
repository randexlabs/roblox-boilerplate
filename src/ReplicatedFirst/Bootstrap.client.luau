local ReplicatedFirst = game:GetService('ReplicatedFirst')

local Features = ReplicatedFirst:WaitForChild('Features')
local Helpers = ReplicatedFirst:WaitForChild('Helpers')
local Loader = require(Helpers:WaitForChild('Loader'))

Loader(Features)
