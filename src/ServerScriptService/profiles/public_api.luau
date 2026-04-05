local types = require './types'

export type ProfilesApi = types.ProfilesApi
export type ProfilesApiDependencies = types.ProfilesApiDependencies

return function(dependencies: ProfilesApiDependencies): ProfilesApi
	local profile_cache = dependencies.profile_cache
	local is_player_active = dependencies.is_player_active
	local wait_for_profile_async = dependencies.wait_for_profile_async

	local function get_profile_async(player: Player): types.PlayerProfile?
		local cached_profile = profile_cache.get_profile(player)
		if cached_profile ~= nil then return cached_profile end

		if is_player_active(player) == false then return nil end

		return wait_for_profile_async(player)
	end

	local function get_profile_data_async(player: Player): types.ProfileData?
		local player_profile = get_profile_async(player)
		if player_profile == nil then return nil end

		return player_profile.Data :: types.ProfileData
	end

	return table.freeze {
		get_profile_async = get_profile_async,
		get_profile_data_async = get_profile_data_async,
	}
end
