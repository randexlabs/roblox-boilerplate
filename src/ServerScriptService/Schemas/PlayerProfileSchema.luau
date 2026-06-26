export type PlayerProfileData = {
	Money: number,
}

local PlayerProfileSchema: PlayerProfileData = {
	Money = 0,
}

return table.freeze(PlayerProfileSchema)
