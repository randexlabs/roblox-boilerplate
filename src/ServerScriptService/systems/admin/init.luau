local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local collect = require(ReplicatedStorage.collect)
local jecs = require(ReplicatedStorage.packages.jecs)
local planck_runservice = require(ReplicatedStorage.packages.planck_runservice)
local phases = planck_runservice.Phases
type World = jecs.World

local commands = script.cmds
local conch = require(ReplicatedStorage.packages.conch)
local config = require(ReplicatedStorage.config)
local DEVELOPER_IDS = config.developers_id

conch.initiate_default_lifecycle()
conch.set_role_permissions('Dev', 'Dev')

for _, cmd in commands:GetChildren() do
	task.spawn(function()
		(require)(cmd)()
	end)
end

local PlayerAdded = collect(Players.PlayerAdded)

local function system(world: World)
	local player = PlayerAdded()
	if not player then return end
	if not DEVELOPER_IDS[player.UserId] then return end

	local user = conch.get_user(player)
	conch.give_roles(user, 'Dev')
end

return {
	system = system,
	phase = phases.Update,
}
