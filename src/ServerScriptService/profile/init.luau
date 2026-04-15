local Players = game:GetService 'Players'

local cache = require(script.cache)
local types = require(script.types)

export type Profile = types.Profile?
export type Data = types.Data?

local function get_profile(player: Player): Profile?
	return cache.get_profile(player)
end

local function is_loaded(player: Player): boolean
	return if get_profile(player) then true else false
end

local function get_profile_async(player: Player): Profile?
	repeat
		task.wait()
	until get_profile(player) or player.Parent ~= Players
	return get_profile(player)
end

local function get_data(player: Player): Data?
	local profile = get_profile(player)
	return profile and profile.Data or nil
end

local function get_data_async(player: Player): Data?
	local profile = get_profile_async(player)
	return profile and profile.Data or nil
end

return table.freeze {
	get_profile = get_profile,
	get_profile_async = get_profile_async,

	get_data = get_data,
	get_data_async = get_data_async,

	is_loaded = is_loaded,
}
