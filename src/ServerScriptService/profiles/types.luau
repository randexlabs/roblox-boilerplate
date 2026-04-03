export type JsonValue =
	nil
	| boolean
	| buffer
	| number
	| string
	| { [string]: JsonValue }
	| { JsonValue }

export type ProfileData = { [string]: JsonValue }

export type ProfileSessionEndSignal = {
	Connect: (self: ProfileSessionEndSignal, callback: () -> ()) -> (),
}

export type PlayerProfile = {
	Data: ProfileData,
	AddUserId: (self: PlayerProfile, user_id: number) -> (),
	Reconcile: (self: PlayerProfile) -> (),
	EndSession: (self: PlayerProfile) -> (),
	OnSessionEnd: ProfileSessionEndSignal,
}

export type PlayerStore = {
	StartSessionAsync: (
		self: PlayerStore,
		profile_key: string,
		config: { Cancel: () -> boolean }
	) -> PlayerProfile?,
}

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

export type ProfilesRuntime = {
	api: ProfilesApi,
	cache: ProfileCache,
	session: PlayerSessionService,
}

return nil
