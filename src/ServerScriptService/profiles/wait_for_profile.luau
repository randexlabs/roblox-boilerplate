local types = require './types'

export type ProfileCache = types.ProfileCache
export type WaitForProfile = types.WaitForProfile
export type WaitForProfileDependencies = types.WaitForProfileDependencies

return function(dependencies: WaitForProfileDependencies): WaitForProfile
	local profile_cache = dependencies.profile_cache
	local is_player_active = dependencies.is_player_active
	local wait_for_next_profile_poll = dependencies.wait_for_next_profile_poll

	return function(player: Player)
		local profile = profile_cache.get_profile(player)
		if profile ~= nil then return profile end

		if not is_player_active(player) then return nil end

		while is_player_active(player) do
			local next_profile = profile_cache.get_profile(player)
			if next_profile ~= nil then return next_profile end

			wait_for_next_profile_poll()
		end

		return nil
	end
end
