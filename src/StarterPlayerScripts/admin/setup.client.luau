local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local conch = require(ReplicatedStorage.packages.conch)
local conch_ui = require(ReplicatedStorage.packages.conch_ui)
local config = require(ReplicatedStorage.config)

local DEVELOPERS_ID = config.developers_id
local localplayer = Players.LocalPlayer

if not DEVELOPERS_ID[localplayer.UserId] then return end
conch.initiate_default_lifecycle()
conch_ui.bind_to(Enum.KeyCode.F4)
