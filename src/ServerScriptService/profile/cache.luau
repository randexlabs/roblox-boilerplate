local types = require(script.Parent.types)
local cache = {} :: { [Player]: Profile }
type Profile = types.Profile

local function has_player(player: Player)
	return if cache[player] then true else false
end

local function add_player(player: Player, profile: Profile)
	if has_player(player) then return end
	cache[player] = profile
end

local function remove_player(player: Player)
	if not has_player(player) then return end
	cache[player] = nil
end

local function get_profile(player: Player)
	return if has_player(player) then cache[player] else nil
end

return table.freeze {
	get_profile = get_profile,
	add_player = add_player,
	remove_player = remove_player,
	has_player = has_player,
}
