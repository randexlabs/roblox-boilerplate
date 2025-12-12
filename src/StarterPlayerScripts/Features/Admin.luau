local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Conch = require(ReplicatedStorage.Packages.Conch)
local ConchUi = require(ReplicatedStorage.Packages.ConchUi)
local DEVELOPERS_ID = require(ReplicatedStorage.Constants.DevelopersID)
local LocalPlayer = Players.LocalPlayer

return function()
	if not DEVELOPERS_ID[LocalPlayer.UserId] then return end
	Conch.initiate_default_lifecycle()
	ConchUi.bind_to(Enum.KeyCode.F4)
end
