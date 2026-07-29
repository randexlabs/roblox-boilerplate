local currency_service = require(script.Parent.Parent.services.currency_service)
export type ReceiptInfo = {
	PlayerId: number,
	ProductId: number,
	PurchaseId: string,
}

export type ProductDefinition = {
	Id: number,
	Name: string,
	Callback: (player: Player, receipt_info: ReceiptInfo) -> any,
}

local coins_100_product: ProductDefinition = {
	Id = 1,
	Name = 'Coins100',
	Callback = function(player: Player, _: ReceiptInfo)
		return currency_service.grant(player, 'Coins', 100)
	end,
}

return coins_100_product
