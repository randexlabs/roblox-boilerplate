local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local DEVELOPERS_ID = require(ReplicatedStorage.constants.developers_id)
local conch = require(ReplicatedStorage.packages.conch)
local commands = script.Parent.cmds

for _, cmd in commands:GetChildren() do
	task.spawn(require, cmd)
end

conch.initiate_default_lifecycle()
conch.set_role_permissions('Dev', 'Dev')

Players.PlayerAdded:Connect(function(player: Player)
	if not DEVELOPERS_ID[player.UserId] then return end
	local user = conch.get_user(player)
	conch.give_roles(user, 'Dev')
end)
