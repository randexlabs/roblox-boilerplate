local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local DEVELOPERS_ID = require(ReplicatedStorage.constants.developers_id)
local conch = require(ReplicatedStorage.packages.conch)
local conch_ui = require(ReplicatedStorage.packages.conch_ui)
local localplayer = Players.LocalPlayer

return function()
	if not DEVELOPERS_ID[localplayer.UserId] then return end
	conch.initiate_default_lifecycle()
	conch_ui.bind_to(Enum.KeyCode.F4)
end
