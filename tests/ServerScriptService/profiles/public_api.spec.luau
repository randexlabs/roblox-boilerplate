local create_cache = require '@src/ServerScriptService/profiles/cache'
local create_public_api = require '@src/ServerScriptService/profiles/public_api'
local test_player = require './test_player'

local run = {}

function run.should_return_cached_profile_without_waiting()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()
	local player_profile = {
		Data = {
			level = 7,
		},
	} :: any
	local wait_call_count = 0

	profile_cache.set_profile(player, player_profile)

	local profiles_api = create_public_api {
		profile_cache = profile_cache,
		is_player_active = function()
			return true
		end,
		wait_for_profile_async = function()
			wait_call_count += 1
			return nil
		end,
	}

	assert(profiles_api.get_profile_async(player) == player_profile)
	assert(wait_call_count == 0)
end

function run.should_wait_for_profile_when_player_is_active()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()
	local player_profile = {
		Data = {
			level = 9,
		},
	} :: any
	local wait_call_count = 0

	local profiles_api = create_public_api {
		profile_cache = profile_cache,
		is_player_active = function()
			return true
		end,
		wait_for_profile_async = function(target_player)
			wait_call_count += 1
			assert(target_player == player)
			return player_profile
		end,
	}

	assert(profiles_api.get_profile_async(player) == player_profile)
	assert(wait_call_count == 1)
end

function run.should_return_nil_without_waiting_when_player_is_inactive()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()
	local wait_call_count = 0

	local profiles_api = create_public_api {
		profile_cache = profile_cache,
		is_player_active = function()
			return false
		end,
		wait_for_profile_async = function()
			wait_call_count += 1
			return nil
		end,
	}

	assert(profiles_api.get_profile_async(player) == nil)
	assert(wait_call_count == 0)
end

function run.should_return_profile_data()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()

	profile_cache.set_profile(
		player,
		{
			Data = {
				level = 11,
			},
		} :: any
	)

	local profiles_api = create_public_api {
		profile_cache = profile_cache,
		is_player_active = function()
			return true
		end,
		wait_for_profile_async = function()
			return nil
		end,
	}

	local profile_data = profiles_api.get_profile_data_async(player)

	assert(profile_data ~= nil)
	assert(profile_data.level == 11)
end

function run.should_return_nil_data_when_profile_is_missing()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()

	local profiles_api = create_public_api {
		profile_cache = profile_cache,
		is_player_active = function()
			return false
		end,
		wait_for_profile_async = function()
			return nil
		end,
	}

	assert(profiles_api.get_profile_data_async(player) == nil)
end

return run
