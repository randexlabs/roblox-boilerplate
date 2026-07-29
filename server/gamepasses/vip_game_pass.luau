local perks_service = require(script.Parent.Parent.services.perks_service)
export type GamePassDefinition = {
	Id: number,
	Name: string,
	Callback: (player: Player) -> any,
}

local vip_game_pass: GamePassDefinition = {
	Id = 1,
	Name = 'Vip',
	Callback = function(player: Player)
		return perks_service.grant_vip(player)
	end,
}

return vip_game_pass
