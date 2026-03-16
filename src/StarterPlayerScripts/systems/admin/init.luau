local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local ecs = require(ReplicatedStorage.pkg.ecs)
local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local phases = planck_runservice.Phases
type World = ecs.World

local locaplayer = Players.LocalPlayer
local conch = require(ReplicatedStorage.pkg.conch)
local conch_ui = require(ReplicatedStorage.pkg.conch_ui)
local config = require(ReplicatedStorage.config)
local DEVELOPER_IDS = config.developers_id

local function system(world: World)
	if not DEVELOPER_IDS[locaplayer.UserId] then return end
	conch.initiate_default_lifecycle()
	conch_ui.bind_to(Enum.KeyCode.F4)
end

return {
	system = system,
	phase = phases.First.Startup,
}
