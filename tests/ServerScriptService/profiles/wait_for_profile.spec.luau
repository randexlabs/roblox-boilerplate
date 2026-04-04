local create_cache = require '@src/ServerScriptService/profiles/cache'
local create_wait_for_profile =
	require '@src/ServerScriptService/profiles/wait_for_profile'
local test_player = require './test_player'

local run = {}

function run.should_return_cached_profile_immediately()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()
	local player_profile = {
		Data = {},
	} :: any
	local wait_call_count = 0

	profile_cache.set_profile(player, player_profile)

	local wait_for_profile_async = create_wait_for_profile {
		profile_cache = profile_cache,
		is_player_active = function()
			return true
		end,
		wait_for_next_profile_poll = function()
			wait_call_count += 1
		end,
	}

	assert(wait_for_profile_async(player) == player_profile)
	assert(wait_call_count == 0)
end

function run.should_return_nil_when_player_is_inactive()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()
	local wait_call_count = 0

	local wait_for_profile_async = create_wait_for_profile {
		profile_cache = profile_cache,
		is_player_active = function()
			return false
		end,
		wait_for_next_profile_poll = function()
			wait_call_count += 1
		end,
	}

	assert(wait_for_profile_async(player) == nil)
	assert(wait_call_count == 0)
end

function run.should_poll_until_profile_is_available()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()
	local player_profile = {
		Data = {
			level = 5,
		},
	} :: any
	local wait_call_count = 0

	local wait_for_profile_async = create_wait_for_profile {
		profile_cache = profile_cache,
		is_player_active = function()
			return wait_call_count < 3
		end,
		wait_for_next_profile_poll = function()
			wait_call_count += 1
			if wait_call_count == 2 then
				profile_cache.set_profile(player, player_profile)
			end
		end,
	}

	assert(wait_for_profile_async(player) == player_profile)
	assert(wait_call_count == 2)
end

return run
