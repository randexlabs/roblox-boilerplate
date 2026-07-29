export type ProfileStoreErrorCode =
	'PlayerNotInGame'
	| 'ProfileLoadFailed'
	| 'ProfileNotLoaded'
	| 'ProfileNotActive'

local profile_store_errors: { [string]: ProfileStoreErrorCode } = {
	PlayerNotInGame = 'PlayerNotInGame',
	ProfileLoadFailed = 'ProfileLoadFailed',
	ProfileNotLoaded = 'ProfileNotLoaded',
	ProfileNotActive = 'ProfileNotActive',
}

return table.freeze(profile_store_errors)
