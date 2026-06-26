local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local RunService = game:GetService 'RunService'
local ServerScriptService = game:GetService 'ServerScriptService'

local PlayerProfileSchema =
	require(ServerScriptService.Schemas.PlayerProfileSchema)
local ProfileStore = require(ServerScriptService.serverpkg.ProfileStore)
local ProfileStoreErrors = require(ReplicatedStorage.Errors.ProfileStoreErrors)
local Result = require(ReplicatedStorage.Shared.Result)

export type PlayerProfileData = PlayerProfileSchema.PlayerProfileData
export type ProfileStoreErrorCode = ProfileStoreErrors.ProfileStoreErrorCode
export type PlayerProfile = any

export type ProfileQueryOperation =
	'ProfileStoreService.GetLoadedProfile'
	| 'ProfileStoreService.WaitForProfileAsync'
export type ProfileQueryError = Result.Error<ProfileStoreErrorCode> & {
	operation: ProfileQueryOperation,
	playerUserId: number,
}
export type ProfileQueryResult = Result.Result<PlayerProfile, ProfileQueryError>

local PLAYER_DATA_STORE_NAME = 'PlayerData'
local GET_LOADED_PROFILE_OPERATION: ProfileQueryOperation =
	'ProfileStoreService.GetLoadedProfile'
local WAIT_FOR_PROFILE_ASYNC_OPERATION: ProfileQueryOperation =
	'ProfileStoreService.WaitForProfileAsync'
local playerDataTemplate: PlayerProfileData =
	PlayerProfileSchema :: PlayerProfileData

local playerStoreRoot =
	ProfileStore.New(PLAYER_DATA_STORE_NAME, playerDataTemplate)
type PlayerStore = typeof(playerStoreRoot.Mock)

local playerStore: PlayerStore = playerStoreRoot

if RunService:IsStudio() then playerStore = playerStoreRoot.Mock end
local activeProfiles: { [Player]: PlayerProfile } = {}
local failedProfileLoads: { [Player]: ProfileStoreErrorCode } = {}
local hasStarted = false

local ProfileStoreService = {}

local function getProfileKey(player: Player): string
	return tostring(player.UserId)
end

local function warnProfileLoadFailed(player: Player)
	warn(
		`[ProfileStoreService] code={ProfileStoreErrors.ProfileLoadFailed} operation=LoadProfile playerUserId={player.UserId}`
	)
end

local function getProfileError(
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

local function endProfileSession(player: Player)
	local profile = activeProfiles[player]

	if profile == nil then return end

	activeProfiles[player] = nil
	failedProfileLoads[player] = nil
	profile:EndSession()
end

local function handleSessionEnd(player: Player)
	activeProfiles[player] = nil
	failedProfileLoads[player] = nil

	if player.Parent == Players then
		player:Kick 'Profile session ended. Please rejoin.'
	end
end

local function loadProfileAsync(player: Player)
	local profile = playerStore:StartSessionAsync(getProfileKey(player), {
		Cancel = function(): boolean
			return player.Parent ~= Players
		end,
	})

	if profile == nil then
		if player.Parent ~= Players then return end

		failedProfileLoads[player] = ProfileStoreErrors.ProfileLoadFailed
		warnProfileLoadFailed(player)
		player:Kick 'Profile load failed. Please rejoin.'

		return
	end

	failedProfileLoads[player] = nil
	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile.OnSessionEnd:Connect(function()
		handleSessionEnd(player)
	end)

	if player.Parent ~= Players then
		profile:EndSession()
		return
	end

	activeProfiles[player] = profile
end

function ProfileStoreService.Start()
	assert(not hasStarted, 'ProfileStoreService.Start must only be called once')

	hasStarted = true

	for _, player in Players:GetPlayers() do
		task.spawn(loadProfileAsync, player)
	end

	Players.PlayerAdded:Connect(function(player)
		loadProfileAsync(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		failedProfileLoads[player] = nil
		endProfileSession(player)
	end)
end

function ProfileStoreService.GetLoadedProfile(
	player: Player
): ProfileQueryResult
	local profile = activeProfiles[player]

	if profile == nil then
		return Result.Err(
			getProfileError(
				player,
				GET_LOADED_PROFILE_OPERATION,
				ProfileStoreErrors.ProfileNotLoaded
			)
		)
	end

	return Result.Ok(profile)
end

function ProfileStoreService.IsProfileActive(player: Player): boolean
	local profile = activeProfiles[player]

	if profile == nil then return false end

	return profile:IsActive()
end

function ProfileStoreService.WaitForProfileAsync(
	player: Player
): ProfileQueryResult
	while true do
		local profile = activeProfiles[player]

		if profile ~= nil then return Result.Ok(profile) end

		local failedCode: ProfileStoreErrorCode? = failedProfileLoads[player]

		if failedCode ~= nil then
			return Result.Err(
				getProfileError(
					player,
					WAIT_FOR_PROFILE_ASYNC_OPERATION,
					failedCode
				)
			)
		end

		if player.Parent ~= Players then
			return Result.Err(
				getProfileError(
					player,
					WAIT_FOR_PROFILE_ASYNC_OPERATION,
					ProfileStoreErrors.PlayerNotInGame
				)
			)
		end

		task.wait()
	end
end

return table.freeze(ProfileStoreService)
