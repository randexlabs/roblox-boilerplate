export type ProfileStoreErrorCode =
	'PlayerNotInGame'
	| 'ProfileLoadFailed'
	| 'ProfileNotLoaded'

local ProfileStoreErrors: { [string]: ProfileStoreErrorCode } = {
	PlayerNotInGame = 'PlayerNotInGame',
	ProfileLoadFailed = 'ProfileLoadFailed',
	ProfileNotLoaded = 'ProfileNotLoaded',
}

return table.freeze(ProfileStoreErrors)
