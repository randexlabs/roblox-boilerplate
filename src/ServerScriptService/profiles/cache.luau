local types = require './types'

export type PlayerProfile = types.PlayerProfile
export type ProfileCache = types.ProfileCache

return function(): ProfileCache
	local profile_by_player: { [Player]: PlayerProfile? } = {}

	local function get_profile(player: Player): PlayerProfile?
		return profile_by_player[player]
	end

	local function set_profile(player: Player, profile: PlayerProfile): ()
		profile_by_player[player] = profile
	end

	local function delete_profile(player: Player): ()
		profile_by_player[player] = nil
	end

	return table.freeze {
		get_profile = get_profile,
		set_profile = set_profile,
		delete_profile = delete_profile,
	}
end
