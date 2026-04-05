local types = require './types'

export type ProfileCache = types.ProfileCache
export type WaitForProfile = types.WaitForProfile
export type WaitForProfileDependencies = types.WaitForProfileDependencies

return function(dependencies: WaitForProfileDependencies): WaitForProfile
	local profile_cache = dependencies.profile_cache
	local is_player_active = dependencies.is_player_active
	local wait_for_next_profile_poll = dependencies.wait_for_next_profile_poll

	local function wait_for_profile_async(player: Player): types.PlayerProfile?
		local cached_profile = profile_cache.get_profile(player)
		if cached_profile ~= nil then return cached_profile end

		if is_player_active(player) == false then return nil end

		while is_player_active(player) do
			local available_profile = profile_cache.get_profile(player)
			if available_profile ~= nil then return available_profile end

			wait_for_next_profile_poll()
		end

		return nil
	end

	return wait_for_profile_async
end
