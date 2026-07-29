export type PlayerProfileData = {
	Money: number,
	ProcessedPurchaseIds: {
		[string]: boolean,
	},
}

local player_profile_schema: PlayerProfileData = {
	Money = 0,
	ProcessedPurchaseIds = {},
}

return table.freeze(player_profile_schema)
