local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local jecs = require(ReplicatedStorage.packages.jecs)
local planck_runservice = require(ReplicatedStorage.packages.planck_runservice)
local phases = planck_runservice.Phases
type World = jecs.World

local locaplayer = Players.LocalPlayer
local conch = require(ReplicatedStorage.packages.conch)
local conch_ui = require(ReplicatedStorage.packages.conch_ui)
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
