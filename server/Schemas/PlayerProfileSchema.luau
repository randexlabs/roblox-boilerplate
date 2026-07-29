export type PlayerProfileData = {
	Money: number,
	ProcessedPurchaseIds: {
		[string]: boolean,
	},
}

local PlayerProfileSchema: PlayerProfileData = {
	Money = 0,
	ProcessedPurchaseIds = {},
}

return table.freeze(PlayerProfileSchema)
