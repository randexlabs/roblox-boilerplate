export type ProfileStoreErrorCode =
	'PlayerNotInGame'
	| 'ProfileLoadFailed'
	| 'ProfileNotLoaded'
	| 'ProfileNotActive'

local ProfileStoreErrors: { [string]: ProfileStoreErrorCode } = {
	PlayerNotInGame = 'PlayerNotInGame',
	ProfileLoadFailed = 'ProfileLoadFailed',
	ProfileNotLoaded = 'ProfileNotLoaded',
	ProfileNotActive = 'ProfileNotActive',
}

return table.freeze(ProfileStoreErrors)
