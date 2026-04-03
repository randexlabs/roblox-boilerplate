local ProfileStore = require(script.Parent.Parent.serverpkg.profilestore)

export type ProfileData = { [string]: ProfileStore.JSONAcceptable }
export type PlayerProfile = ProfileStore.Profile<ProfileData>
export type PlayerStore = ProfileStore.ProfileStore<ProfileData>

export type ProfileCache = {
	get_profile: (player: Player) -> PlayerProfile?,
	set_profile: (player: Player, profile: PlayerProfile) -> (),
	delete_profile: (player: Player) -> (),
}

export type WaitForProfile = (player: Player) -> PlayerProfile?

export type WaitForProfileDependencies = {
	profile_cache: ProfileCache,
	is_player_active: (player: Player) -> boolean,
	wait_for_next_profile_poll: () -> (),
}

export type ProfilesApi = {
	get_profile_async: (player: Player) -> PlayerProfile?,
	get_profile_data_async: (player: Player) -> ProfileData?,
}

export type ProfilesApiDependencies = {
	profile_cache: ProfileCache,
	is_player_active: (player: Player) -> boolean,
	wait_for_profile_async: WaitForProfile,
}

export type PlayerSessionService = {
	load_profile_async: (player: Player) -> (),
	unload_profile: (player: Player) -> (),
}

export type PlayerSessionDependencies = {
	profile_cache: ProfileCache,
	is_player_active: (player: Player) -> boolean,
	kick_player_with_message: (player: Player, message: string) -> (),
	profile_store: PlayerStore,
}

export type StoreConfig = {
	profile_store_library: ProfileStore.ProfileStoreModule,
	profile_store_name: string,
	default_profile_data: ProfileData,
}

export type ProfilesRuntime = {
	api: ProfilesApi,
	cache: ProfileCache,
	session: PlayerSessionService,
}

return nil
