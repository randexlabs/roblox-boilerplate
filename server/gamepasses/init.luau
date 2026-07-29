local ServerScriptService = game:GetService 'ServerScriptService'

local vip_game_pass = require(ServerScriptService.gamepasses.vip_game_pass)

export type GamePassDefinition = vip_game_pass.GamePassDefinition

local game_pass_catalog: { [number]: GamePassDefinition } = {}

assert(
	game_pass_catalog[vip_game_pass.Id] == nil,
	`Duplicate game pass id: {vip_game_pass.Id}`
)
game_pass_catalog[vip_game_pass.Id] = vip_game_pass

return table.freeze(game_pass_catalog)
