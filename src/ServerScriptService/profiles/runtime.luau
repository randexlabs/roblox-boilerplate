local Players = game:GetService 'Players'
local ServerScriptService = game:GetService 'ServerScriptService'

local ProfileStore = require(ServerScriptService.serverpkg.profilestore)

local create_cache = require './cache'
local create_public_api = require './public_api'
local create_session_service = require './session'
local create_store = require './store'
local create_wait_for_profile = require './wait_for_profile'
local runtime_types = require './runtime_types'
local types = require './types'

type ProfileCache = types.ProfileCache
type ProfilesApi = types.ProfilesApi
type PlayerSessionService = types.PlayerSessionService
type ProfilesRuntime = types.ProfilesRuntime
type StoreConfig = runtime_types.StoreConfig

local function is_player_active(player: Player): boolean
	return player.Parent == Players
end

local function kick_player_with_message(player: Player, message: string)
	player:Kick(message)
end

local function wait_for_next_profile_poll()
	task.wait()
end

local profile_cache: ProfileCache = create_cache()
local profile_store_config: StoreConfig = {
	profile_store_library = ProfileStore,
	profile_store_name = 'Profiles',
	default_profile_data = {},
}
local profile_store = create_store(profile_store_config)
local wait_for_profile_async = create_wait_for_profile {
	profile_cache = profile_cache,
	is_player_active = is_player_active,
	wait_for_next_profile_poll = wait_for_next_profile_poll,
}
local player_session_service: PlayerSessionService = create_session_service {
	profile_cache = profile_cache,
	is_player_active = is_player_active,
	kick_player_with_message = kick_player_with_message,
	profile_store = profile_store,
}
local profiles_api: ProfilesApi = create_public_api {
	profile_cache = profile_cache,
	is_player_active = is_player_active,
	wait_for_profile_async = wait_for_profile_async,
}

return table.freeze {
	api = profiles_api,
	cache = profile_cache,
	session = player_session_service,
} :: ProfilesRuntime
