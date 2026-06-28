local Result = require(game:GetService('ReplicatedStorage').Shared.Result)

export type GrantSuccess = {
	PerkId: string,
}

export type GrantError = Result.Error<'PerkGrantFailed'>
export type GrantResult = Result.Result<GrantSuccess, GrantError>

local PerksService = {}

function PerksService.GrantVip(player: Player): GrantResult
	warn(
		`[PerksService] placeholder grant playerUserId={player.UserId} perkId=Vip`
	)

	return Result.Ok {
		PerkId = 'Vip',
	}
end

return table.freeze(PerksService)
