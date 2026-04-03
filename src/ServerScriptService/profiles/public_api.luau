local types = require(script.Parent.types)

export type ProfilesApi = types.ProfilesApi
export type ProfilesApiDependencies = types.ProfilesApiDependencies

return function(dependencies: ProfilesApiDependencies): ProfilesApi
	local profile_cache = dependencies.profile_cache
	local is_player_active = dependencies.is_player_active
	local wait_for_profile_async = dependencies.wait_for_profile_async

	local function get_profile_async(player: Player): types.PlayerProfile?
		local profile = profile_cache.get_profile(player)
		if profile ~= nil then return profile end

		if not is_player_active(player) then return nil end

		return wait_for_profile_async(player)
	end

	local function get_profile_data_async(player: Player): types.ProfileData?
		local profile = get_profile_async(player)
		if profile == nil then return nil end

		return profile.Data :: types.ProfileData
	end

	return table.freeze {
		get_profile_async = get_profile_async,
		get_profile_data_async = get_profile_data_async,
	}
end
