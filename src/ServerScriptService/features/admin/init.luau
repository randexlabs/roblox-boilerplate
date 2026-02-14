local Players = game:GetService('Players')
local ReplicatedFirst = game:GetService('ReplicatedFirst')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local DEVELOPERS_ID = require(ReplicatedStorage.constants.developers_id)
local conch = require(ReplicatedStorage.packages.conch)
local loader = require(ReplicatedFirst.helpers.loader)
local commands = script.commands

return function()
	conch.initiate_default_lifecycle()
	conch.set_role_permissions('Dev', 'Dev')
	loader(commands)

	Players.PlayerAdded:Connect(function(player: Player)
		if not DEVELOPERS_ID[player.UserId] then return end
		local user = conch.get_user(player)
		conch.give_roles(user, 'Dev')
	end)
end
