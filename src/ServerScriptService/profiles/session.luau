local types = require './types'

export type ProfileCache = types.ProfileCache
export type PlayerSessionService = types.PlayerSessionService
export type PlayerSessionDependencies = types.PlayerSessionDependencies
export type PlayerProfile = types.PlayerProfile

return function(dependencies: PlayerSessionDependencies): PlayerSessionService
	local profile_cache = dependencies.profile_cache
	local is_player_active = dependencies.is_player_active
	local kick_player_with_message = dependencies.kick_player_with_message
	local profile_store = dependencies.profile_store

	local function handle_profile_session_end(player: Player): ()
		profile_cache.delete_profile(player)

		if is_player_active(player) == false then return end

		kick_player_with_message(
			player,
			'Profile session ended. Please rejoin.'
		)
	end

	local function configure_profile_session(
		player: Player,
		profile: PlayerProfile
	): ()
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile.OnSessionEnd:Connect(function()
			handle_profile_session_end(player)
		end)
	end

	local function load_profile_async(player: Player): ()
		local profile_key = `{player.UserId}`
		local player_profile = profile_store:StartSessionAsync(profile_key, {
			Cancel = function()
				return is_player_active(player) == false
			end,
		})

		if player_profile == nil then
			if is_player_active(player) == false then return end

			kick_player_with_message(
				player,
				'Profile failed to load. Please rejoin.'
			)
			return
		end

		configure_profile_session(player, player_profile)

		if is_player_active(player) == false then
			player_profile:EndSession()
			return
		end

		profile_cache.set_profile(player, player_profile)
	end

	local function unload_profile(player: Player): ()
		local player_profile = profile_cache.get_profile(player)
		if player_profile == nil then return end

		player_profile:EndSession()
	end

	return table.freeze {
		load_profile_async = load_profile_async,
		unload_profile = unload_profile,
	}
end
