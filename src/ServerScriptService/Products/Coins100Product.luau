local CurrencyService = require(script.Parent.Parent.Services.CurrencyService)
export type ReceiptInfo = {
	PlayerId: number,
	ProductId: number,
	PurchaseId: string,
}

export type ProductDefinition = {
	Id: number,
	Name: string,
	Callback: (player: Player, receiptInfo: ReceiptInfo) -> any,
}

local Coins100Product: ProductDefinition = {
	Id = 1,
	Name = 'Coins100',
	Callback = function(player: Player, _: ReceiptInfo)
		return CurrencyService.Grant(player, 'Coins', 100)
	end,
}

return Coins100Product
