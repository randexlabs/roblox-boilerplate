local ServerScriptService = game:GetService 'ServerScriptService'

local ProfileStore = require(ServerScriptService.serverpkg.profilestore)
local types = require './types'

export type ProfileData = types.ProfileData
export type PlayerStore = types.PlayerStore

export type ProfileStoreModule = typeof(ProfileStore)

export type StoreConfig = {
	profile_store_library: ProfileStoreModule,
	profile_store_name: string,
	default_profile_data: ProfileData,
}

return nil
