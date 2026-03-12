local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local RunService = game:GetService 'RunService'

local jecs = require(ReplicatedStorage.pkg.jecs)

local ServerScriptService = game:GetService 'ServerScriptService'
local player_data = require(ServerScriptService.schemas.player_data)
local profilestore = require(ServerScriptService.serverpkg.profilestore)
local world = require(ReplicatedStorage.world)

local types = require(script.Parent.types)
type profile = types.profile
type store = types.store

local player_store = world:component() :: jecs.Component<profile>

world:set(
	player_store,
	player_store,
	profilestore.New('IDK', player_data) :: any
)

return (
	if RunService:IsServer() then player_store else nil :: any
) :: jecs.Component<store>
