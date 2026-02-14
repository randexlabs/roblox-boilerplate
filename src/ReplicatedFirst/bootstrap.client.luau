local ReplicatedFirst = game:GetService('ReplicatedFirst')

local features = ReplicatedFirst:WaitForChild('features')
local helpers = ReplicatedFirst:WaitForChild('helpers')
local loader = require(helpers:WaitForChild('loader'))

loader(features)
