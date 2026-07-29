local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local RunService = game:GetService 'RunService'
local ServerScriptService = game:GetService 'ServerScriptService'

local player_profile_schema =
	require(ServerScriptService.schemas.player_profile_schema)
local profile_store = require(ServerScriptService.serverpkg.ProfileStore)
local profile_store_errors =
	require(ReplicatedStorage.errors.profile_store_errors)
local result = require(ReplicatedStorage.shared.result)

export type PlayerProfileData = player_profile_schema.PlayerProfileData
export type ProfileStoreErrorCode = profile_store_errors.ProfileStoreErrorCode
export type PlayerProfile = any

export type ProfileQueryOperation =
	'profile_store_service.get_loaded_profile'
	| 'profile_store_service.wait_for_profile_async'
export type ProfileSaveOperation = 'profile_store_service.save_profile_async'
export type ProfileQueryError = result.Error<ProfileStoreErrorCode> & {
	operation: ProfileQueryOperation,
	playerUserId: number,
}
export type ProfileQueryResult = result.Result<PlayerProfile, ProfileQueryError>
export type ProfileSaveError = result.Error<ProfileStoreErrorCode> & {
	operation: ProfileSaveOperation,
	playerUserId: number,
}
export type ProfileSaveResult = result.Result<{}, ProfileSaveError>

local PLAYER_DATA_STORE_NAME = 'PlayerData'
local GET_LOADED_PROFILE_OPERATION: ProfileQueryOperation =
	'profile_store_service.get_loaded_profile'
local WAIT_FOR_PROFILE_ASYNC_OPERATION: ProfileQueryOperation =
	'profile_store_service.wait_for_profile_async'
local SAVE_PROFILE_ASYNC_OPERATION: ProfileSaveOperation =
	'profile_store_service.save_profile_async'
local player_data_template: PlayerProfileData =
	player_profile_schema :: PlayerProfileData

local player_store_root =
	profile_store.New(PLAYER_DATA_STORE_NAME, player_data_template)
type PlayerStore = typeof(player_store_root.Mock)

local player_store: PlayerStore = player_store_root

if RunService:IsStudio() then player_store = player_store_root.Mock end
local active_profiles: { [Player]: PlayerProfile } = {}
local failed_profile_loads: { [Player]: ProfileStoreErrorCode } = {}
local has_started = false

local profile_store_service = {}

local function get_profile_key(player: Player): string
	return tostring(player.UserId)
end

local function warn_profile_load_failed(player: Player)
	warn(
		`[profile_store_service] code={profile_store_errors.ProfileLoadFailed} operation=LoadProfile playerUserId={player.UserId}`
	)
end

local function get_profile_error(
	player: Player,
	operation: ProfileQueryOperation,
	code: ProfileStoreErrorCode
): ProfileQueryError
	return {
		code = code,
		operation = operation,
		playerUserId = player.UserId,
	}
end

local function get_profile_save_error(
	player: Player,
	code: ProfileStoreErrorCode
): ProfileSaveError
	return {
		code = code,
		operation = SAVE_PROFILE_ASYNC_OPERATION,
		playerUserId = player.UserId,
	}
end

local function end_profile_session(player: Player)
	local profile = active_profiles[player]

	if profile == nil then return end

	active_profiles[player] = nil
	failed_profile_loads[player] = nil
	profile:EndSession()
end

local function handle_session_end(player: Player)
	active_profiles[player] = nil
	failed_profile_loads[player] = nil

	if player.Parent == Players then
		player:Kick 'Profile session ended. Please rejoin.'
	end
end

local function load_profile_async(player: Player)
	local profile = player_store:StartSessionAsync(get_profile_key(player), {
		Cancel = function(): boolean
			return player.Parent ~= Players
		end,
	})

	if profile == nil then
		if player.Parent ~= Players then return end

		failed_profile_loads[player] = profile_store_errors.ProfileLoadFailed
		warn_profile_load_failed(player)
		player:Kick 'Profile load failed. Please rejoin.'

		return
	end

	failed_profile_loads[player] = nil
	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile.OnSessionEnd:Connect(function()
		handle_session_end(player)
	end)

	if player.Parent ~= Players then
		profile:EndSession()
		return
	end

	active_profiles[player] = profile
end

function profile_store_service.start()
	assert(
		not has_started,
		'profile_store_service.start must only be called once'
	)

	has_started = true

	for _, player in Players:GetPlayers() do
		task.spawn(load_profile_async, player)
	end

	Players.PlayerAdded:Connect(function(player)
		load_profile_async(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		failed_profile_loads[player] = nil
		end_profile_session(player)
	end)
end

function profile_store_service.get_loaded_profile(
	player: Player
): ProfileQueryResult
	local profile = active_profiles[player]

	if profile == nil then
		return result.err(
			get_profile_error(
				player,
				GET_LOADED_PROFILE_OPERATION,
				profile_store_errors.ProfileNotLoaded
			)
		)
	end

	return result.ok(profile)
end

function profile_store_service.is_profile_active(player: Player): boolean
	local profile = active_profiles[player]

	if profile == nil then return false end

	return profile:IsActive()
end

function profile_store_service.wait_for_profile_async(
	player: Player
): ProfileQueryResult
	while true do
		local profile = active_profiles[player]

		if profile ~= nil then return result.ok(profile) end

		local failed_code: ProfileStoreErrorCode? = failed_profile_loads[player]

		if failed_code ~= nil then
			return result.err(
				get_profile_error(
					player,
					WAIT_FOR_PROFILE_ASYNC_OPERATION,
					failed_code
				)
			)
		end

		if player.Parent ~= Players then
			return result.err(
				get_profile_error(
					player,
					WAIT_FOR_PROFILE_ASYNC_OPERATION,
					profile_store_errors.PlayerNotInGame
				)
			)
		end

		task.wait()
	end
end

function profile_store_service.save_profile_async(
	player: Player
): ProfileSaveResult
	local profile = active_profiles[player]

	if profile == nil then
		return result.err(
			get_profile_save_error(
				player,
				profile_store_errors.ProfileNotLoaded
			)
		)
	end

	if not profile:IsActive() then
		return result.err(
			get_profile_save_error(
				player,
				profile_store_errors.ProfileNotActive
			)
		)
	end

	local save_completed = false
	local save_connection

	save_connection = profile.OnAfterSave:Connect(function()
		save_completed = true
	end)

	profile:Save()

	while not save_completed do
		if save_connection == nil then break end

		if active_profiles[player] ~= profile then
			save_connection:Disconnect()
			return result.err(
				get_profile_save_error(
					player,
					profile_store_errors.ProfileNotLoaded
				)
			)
		end

		if player.Parent ~= Players then
			save_connection:Disconnect()
			return result.err(
				get_profile_save_error(
					player,
					profile_store_errors.PlayerNotInGame
				)
			)
		end

		if not profile:IsActive() then
			save_connection:Disconnect()
			return result.err(
				get_profile_save_error(
					player,
					profile_store_errors.ProfileNotActive
				)
			)
		end

		task.wait()
	end

	save_connection:Disconnect()

	return result.ok {}
end

return table.freeze(profile_store_service)
