local Players = game:GetService('Players')

local Conch = require('@Pkg/Conch')
local ConchUi = require('@Pkg/ConchUi')
local DEVELOPERS_ID = require('@Shared/Constants/DevelopersID')
local LocalPlayer = Players.LocalPlayer

return function()
	if not DEVELOPERS_ID[LocalPlayer.UserId] then return end
	Conch.initiate_default_lifecycle()
	ConchUi.bind_to(Enum.KeyCode.F4)
end
