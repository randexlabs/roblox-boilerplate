local Players = game:GetService('Players')

local Conch = require('@Pkg/Conch')
local DEVELOPERS_ID = require('@Shared/Constants/DevelopersID')
local Loader = require('@SharedFirst/Helpers/Loader')

return function()
	Conch.initiate_default_lifecycle()
	Conch.set_role_permissions('Dev', 'Dev')
	Loader(script.Commands)

	Players.PlayerAdded:Connect(function(player: Player)
		if not DEVELOPERS_ID[player.UserId] then return end
		local User = Conch.get_user(player)
		Conch.give_roles(User, 'Dev')
	end)
end
