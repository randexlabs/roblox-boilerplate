local result = require(game:GetService('ReplicatedStorage').shared.result)

export type GrantSuccess = {
	CurrencyId: string,
	Amount: number,
}

export type GrantError = result.Error<'CurrencyGrantFailed'>
export type GrantResult = result.Result<GrantSuccess, GrantError>

local currency_service = {}

function currency_service.grant(
	player: Player,
	currency_id: string,
	amount: number
): GrantResult
	warn(
		`[currency_service] placeholder grant playerUserId={player.UserId} currencyId={currency_id} amount={amount}`
	)

	return result.ok {
		CurrencyId = currency_id,
		Amount = amount,
	}
end

return table.freeze(currency_service)
