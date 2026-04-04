local create_cache = require '@src/ServerScriptService/profiles/cache'
local test_player = require './test_player'

local run = {}

function run.should_store_and_return_profile()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()
	local player_profile = {
		Data = {
			level = 3,
		},
	} :: any

	profile_cache.set_profile(player, player_profile)

	assert(profile_cache.get_profile(player) == player_profile)
end

function run.should_delete_profile()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()

	profile_cache.set_profile(
		player,
		{
			Data = {},
		} :: any
	)
	profile_cache.delete_profile(player)

	assert(profile_cache.get_profile(player) == nil)
end

return run
