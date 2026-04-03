local types = require(script.Parent.types)

export type ProfileCache = types.ProfileCache
export type PlayerSessionService = types.PlayerSessionService
export type PlayerSessionDependencies = types.PlayerSessionDependencies
export type PlayerProfile = types.PlayerProfile

return function(dependencies: PlayerSessionDependencies): PlayerSessionService
	local profile_cache = dependencies.profile_cache
	local is_player_active = dependencies.is_player_active
	local kick_player_with_message = dependencies.kick_player_with_message
	local profile_store = dependencies.profile_store

	local function handle_profile_session_end(player: Player)
		profile_cache.delete_profile(player)

		if not is_player_active(player) then return end

		kick_player_with_message(
			player,
			'Profile session ended. Please rejoin.'
		)
	end

	local function configure_profile_session(
		player: Player,
		profile: PlayerProfile
	)
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile.OnSessionEnd:Connect(function()
			handle_profile_session_end(player)
		end)
	end

	local function load_profile_async(player: Player)
		local profile = profile_store:StartSessionAsync(`{player.UserId}`, {
			Cancel = function()
				return not is_player_active(player)
			end,
		})

		if profile == nil then
			if not is_player_active(player) then return end

			kick_player_with_message(
				player,
				'Profile failed to load. Please rejoin.'
			)
			return
		end

		configure_profile_session(player, profile)

		if not is_player_active(player) then
			profile:EndSession()
			return
		end

		profile_cache.set_profile(player, profile)
	end

	local function unload_profile(player: Player)
		local profile = profile_cache.get_profile(player)
		if profile == nil then return end

		profile:EndSession()
	end

	return table.freeze {
		load_profile_async = load_profile_async,
		unload_profile = unload_profile,
	}
end
