local create_cache = require '@src/ServerScriptService/profiles/cache'
local create_session_service =
	require '@src/ServerScriptService/profiles/session'
local types = require '@src/ServerScriptService/profiles/types'
local test_player = require './test_player'

local run = {}

local function create_player_profile()
	local session_end_callbacks: { () -> () } = {}
	local reconcile_call_count = 0
	local end_session_call_count = 0
	local player_profile = {
		Data = {
			level = 1,
		},
		added_user_id_list = {},
		OnSessionEnd = {
			Connect = function(_, callback)
				table.insert(session_end_callbacks, callback)
			end,
		},
	}

	function player_profile:AddUserId(user_id)
		table.insert(self.added_user_id_list, user_id)
	end

	function player_profile:Reconcile()
		reconcile_call_count += 1
	end

	function player_profile:EndSession()
		end_session_call_count += 1
	end

	player_profile.get_reconcile_call_count = function()
		return reconcile_call_count
	end

	player_profile.get_end_session_call_count = function()
		return end_session_call_count
	end

	return player_profile, session_end_callbacks
end

function run.should_load_profile_and_cache_it()
	local profile_cache = create_cache()
	local player = test_player.create_test_player(44)
	local player_profile, session_end_callbacks = create_player_profile()
	local cancel_call_count = 0

	local player_session_service = create_session_service {
		profile_cache = profile_cache,
		is_player_active = function(target_player)
			return target_player == player
		end,
		kick_player_with_message = function()
			error 'kick should not be called'
		end,
		profile_store = {
			StartSessionAsync = function(_, profile_key, config)
				assert(profile_key == '44')
				cancel_call_count += 1
				assert(config.Cancel() == false)
				return player_profile
			end,
		} :: any,
	}

	player_session_service.load_profile_async(player)

	assert(profile_cache.get_profile(player) == player_profile)
	assert(#player_profile.added_user_id_list == 1)
	assert(player_profile.added_user_id_list[1] == 44)
	assert(player_profile.get_reconcile_call_count() == 1)
	assert(#session_end_callbacks == 1)
	assert(cancel_call_count == 1)
end

function run.should_end_session_without_caching_when_player_becomes_inactive()
	local profile_cache = create_cache()
	local player = test_player.create_test_player(55)
	local end_session_call_count = 0
	local player_profile: types.PlayerProfile = {
		Data = {},
		AddUserId = function(_self: types.PlayerProfile, _user_id: number)
		end,
		OnSessionEnd = {
			Connect = function(_self, _callback: () -> ())
			end,
		},
		Reconcile = function(_self: types.PlayerProfile)
		end,
		EndSession = function(_self: types.PlayerProfile)
			end_session_call_count += 1
		end,
	}

	local player_session_service = create_session_service {
		profile_cache = profile_cache,
		is_player_active = function()
			return false
		end,
		kick_player_with_message = function()
			error 'kick should not be called'
		end,
		profile_store = {
			StartSessionAsync = function()
				return player_profile
			end,
		},
	}

	player_session_service.load_profile_async(player)

	assert(profile_cache.get_profile(player) == nil)
	assert(end_session_call_count == 1)
end

function run.should_kick_player_when_profile_fails_to_load()
	local profile_cache = create_cache()
	local player = test_player.create_test_player(99)

	local player_session_service = create_session_service {
		profile_cache = profile_cache,
		is_player_active = function()
			return true
		end,
		kick_player_with_message = function(target_player, message)
			target_player:Kick(message)
		end,
		profile_store = {
			StartSessionAsync = function()
				return nil
			end,
		},
	}

	player_session_service.load_profile_async(player)

	local kick_message_list = test_player.get_kick_message_list(player)
	assert(#kick_message_list == 1)
	assert(kick_message_list[1] == 'Profile failed to load. Please rejoin.')
	assert(profile_cache.get_profile(player) == nil)
end

function run.should_unload_profile_by_ending_session()
	local profile_cache = create_cache()
	local player = test_player.create_test_player()
	local end_session_call_count = 0
	local player_profile = {
		Data = {},
	}

	function player_profile:EndSession()
		end_session_call_count += 1
	end

	profile_cache.set_profile(player, player_profile :: any)

	local player_session_service = create_session_service {
		profile_cache = profile_cache,
		is_player_active = function()
			return true
		end,
		kick_player_with_message = function()
			error 'kick should not be called'
		end,
		profile_store = {} :: any,
	}

	player_session_service.unload_profile(player)

	assert(end_session_call_count == 1)
end

function run.should_delete_cached_profile_and_kick_on_session_end()
	local profile_cache = create_cache()
	local player = test_player.create_test_player(77)
	local player_profile, session_end_callbacks = create_player_profile()

	local player_session_service = create_session_service {
		profile_cache = profile_cache,
		is_player_active = function()
			return true
		end,
		kick_player_with_message = function(target_player, message)
			target_player:Kick(message)
		end,
		profile_store = {
			StartSessionAsync = function()
				return player_profile
			end,
		} :: any,
	}

	player_session_service.load_profile_async(player)
	local on_session_end = session_end_callbacks[1]
	assert(on_session_end ~= nil)
	on_session_end()

	local kick_message_list = test_player.get_kick_message_list(player)
	assert(profile_cache.get_profile(player) == nil)
	assert(#kick_message_list == 1)
	assert(kick_message_list[1] == 'Profile session ended. Please rejoin.')
end

return run
