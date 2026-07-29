local MarketplaceService = game:GetService 'MarketplaceService'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local ServerScriptService = game:GetService 'ServerScriptService'

local game_pass_catalog = require(ServerScriptService.gamepasses)
local monetization_errors =
	require(ReplicatedStorage.errors.monetization_errors)
local result = require(ReplicatedStorage.shared.result)

export type MonetizationErrorCode = monetization_errors.MonetizationErrorCode
export type OwnsGamePassOperation = 'monetization_service.owns_game_pass_async'
export type ApplyGamePassOperation = 'monetization_service.apply_game_pass_async'

export type OwnsGamePassError = result.Error<MonetizationErrorCode> & {
	operation: OwnsGamePassOperation,
	playerUserId: number,
	gamePassId: number,
}
export type ApplyGamePassError = result.Error<MonetizationErrorCode> & {
	operation: ApplyGamePassOperation,
	playerUserId: number,
	gamePassId: number,
}

export type OwnsGamePassResult = result.Result<boolean, OwnsGamePassError>
export type ApplyGamePassResult = result.Result<{}, ApplyGamePassError>

type GamePassHandler = (player: Player) -> any

local OWNS_GAME_PASS_OPERATION: OwnsGamePassOperation =
	'monetization_service.owns_game_pass_async'
local APPLY_GAME_PASS_OPERATION: ApplyGamePassOperation =
	'monetization_service.apply_game_pass_async'

local game_passes = {}

function game_passes.owns_game_pass_async(
	player: Player,
	game_pass_id: number
): OwnsGamePassResult
	if game_pass_catalog[game_pass_id] == nil then
		local error_payload: OwnsGamePassError = {
			code = monetization_errors.UnknownGamePass,
			operation = OWNS_GAME_PASS_OPERATION,
			playerUserId = player.UserId,
			gamePassId = game_pass_id,
		}

		return result.err(error_payload)
	end

	local success, owns_result = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(
			player.UserId,
			game_pass_id
		)
	end)

	if not success then
		local error_payload: OwnsGamePassError = {
			code = monetization_errors.GamePassOwnershipCheckFailed,
			operation = OWNS_GAME_PASS_OPERATION,
			playerUserId = player.UserId,
			gamePassId = game_pass_id,
			cause = tostring(owns_result),
		}

		return result.err(error_payload)
	end

	return result.ok(owns_result)
end

function game_passes.apply_game_pass_async(
	player: Player,
	game_pass_id: number
): ApplyGamePassResult
	local game_pass_definition = game_pass_catalog[game_pass_id]

	if game_pass_definition == nil then
		local error_payload: ApplyGamePassError = {
			code = monetization_errors.UnknownGamePass,
			operation = APPLY_GAME_PASS_OPERATION,
			playerUserId = player.UserId,
			gamePassId = game_pass_id,
		}

		return result.err(error_payload)
	end

	local callback_result = (game_pass_definition.Callback :: GamePassHandler)(
		player
	)

	if not callback_result.ok then
		local error_payload: ApplyGamePassError = {
			code = monetization_errors.GamePassGrantFailed,
			operation = APPLY_GAME_PASS_OPERATION,
			playerUserId = player.UserId,
			gamePassId = game_pass_id,
			cause = tostring(callback_result.error.code),
		}

		return result.err(error_payload)
	end

	return result.ok {}
end

return table.freeze(game_passes)
