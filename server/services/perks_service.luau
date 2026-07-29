local result = require(game:GetService('ReplicatedStorage').shared.result)

export type GrantSuccess = {
	PerkId: string,
}

export type GrantError = result.Error<'PerkGrantFailed'>
export type GrantResult = result.Result<GrantSuccess, GrantError>

local perks_service = {}

function perks_service.grant_vip(player: Player): GrantResult
	warn(
		`[perks_service] placeholder grant playerUserId={player.UserId} perkId=Vip`
	)

	return result.ok {
		PerkId = 'Vip',
	}
end

return table.freeze(perks_service)
