local ServerScriptService = game:GetService 'ServerScriptService'

local VipGamePass = require(ServerScriptService.Gamepasses.VipGamePass)

export type GamePassDefinition = VipGamePass.GamePassDefinition

local GamePassCatalog: { [number]: GamePassDefinition } = {}

assert(
	GamePassCatalog[VipGamePass.Id] == nil,
	`Duplicate game pass id: {VipGamePass.Id}`
)
GamePassCatalog[VipGamePass.Id] = VipGamePass

return table.freeze(GamePassCatalog)
