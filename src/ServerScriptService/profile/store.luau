local RunService = game:GetService 'RunService'
local ServerScriptService = game:GetService 'ServerScriptService'
local profilestore = require(ServerScriptService.serverpkg.profilestore)
local schema = require(script.Parent.schema)
local store = profilestore.New('PlayerData', schema)

if RunService:IsStudio() then store = store.Mock :: any end
return store
