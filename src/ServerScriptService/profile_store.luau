local RunService = game:GetService 'RunService'
local ServerScriptService = game:GetService 'ServerScriptService'

local profile_data_schema = require(script.Parent.profile_data_schema)
local profilestore = require(ServerScriptService.serverpkg.profilestore)

local profile_store = profilestore.New('PlayerData', profile_data_schema)

if RunService:IsStudio() then profile_store = profile_store.Mock :: any end

return profile_store
