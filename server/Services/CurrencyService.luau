local Result = require(game:GetService('ReplicatedStorage').Shared.Result)

export type GrantSuccess = {
	CurrencyId: string,
	Amount: number,
}

export type GrantError = Result.Error<'CurrencyGrantFailed'>
export type GrantResult = Result.Result<GrantSuccess, GrantError>

local CurrencyService = {}

function CurrencyService.Grant(
	player: Player,
	currencyId: string,
	amount: number
): GrantResult
	warn(
		`[CurrencyService] placeholder grant playerUserId={player.UserId} currencyId={currencyId} amount={amount}`
	)

	return Result.Ok {
		CurrencyId = currencyId,
		Amount = amount,
	}
end

return table.freeze(CurrencyService)
