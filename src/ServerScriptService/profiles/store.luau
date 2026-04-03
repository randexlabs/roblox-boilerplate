local runtime_types = require './runtime_types'
local types = require './types'

export type ProfileData = types.ProfileData
export type PlayerStore = types.PlayerStore
export type StoreConfig = runtime_types.StoreConfig

return function(config: StoreConfig): PlayerStore
	local profile_store_library = config.profile_store_library
	local default_profile_data = config.default_profile_data
	local profile_store_name = config.profile_store_name

	local player_store = profile_store_library.New(
		profile_store_name,
		default_profile_data :: any
	) :: any

	return player_store :: PlayerStore
end
