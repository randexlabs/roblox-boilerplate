local PerksService = require(script.Parent.Parent.Services.PerksService)
export type GamePassDefinition = {
	Id: number,
	Name: string,
	Callback: (player: Player) -> any,
}

local VipGamePass: GamePassDefinition = {
	Id = 1,
	Name = 'Vip',
	Callback = function(player: Player)
		return PerksService.GrantVip(player)
	end,
}

return VipGamePass
