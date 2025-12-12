local Players = game:GetService('Players')
local ReplicatedFirst = game:GetService('ReplicatedFirst')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Conch = require(ReplicatedStorage.Packages.Conch)
local DEVELOPERS_ID = require(ReplicatedStorage.Constants.DevelopersID)
local Loader = require(ReplicatedFirst.Helpers.Loader)
local Commands = script.Commands

return function()
	Conch.initiate_default_lifecycle()
	Conch.set_role_permissions('Dev', 'Dev')
	Loader(Commands)

	Players.PlayerAdded:Connect(function(player: Player)
		if not DEVELOPERS_ID[player.UserId] then return end
		local User = Conch.get_user(player)
		Conch.give_roles(User, 'Dev')
	end)
end
