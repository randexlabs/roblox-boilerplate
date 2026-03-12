local ServerScriptService = game:GetService 'ServerScriptService'

local player_data = require(ServerScriptService.schemas.player_data)
local profilestore = require(ServerScriptService.serverpkg.profilestore)

export type store = typeof(profilestore.New('IDK', player_data))
export type profile = typeof(((nil :: any) :: store):StartSessionAsync('', {}))

return nil
