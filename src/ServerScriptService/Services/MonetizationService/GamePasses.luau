local MarketplaceService = game:GetService 'MarketplaceService'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local ServerScriptService = game:GetService 'ServerScriptService'

local GamePassCatalog = require(ServerScriptService.Gamepasses)
local MonetizationErrors = require(ReplicatedStorage.Errors.MonetizationErrors)
local Result = require(ReplicatedStorage.Shared.Result)

export type MonetizationErrorCode = MonetizationErrors.MonetizationErrorCode
export type OwnsGamePassOperation = 'MonetizationService.OwnsGamePassAsync'
export type ApplyGamePassOperation = 'MonetizationService.ApplyGamePassAsync'

export type OwnsGamePassError = Result.Error<MonetizationErrorCode> & {
	operation: OwnsGamePassOperation,
	playerUserId: number,
	gamePassId: number,
}
export type ApplyGamePassError = Result.Error<MonetizationErrorCode> & {
	operation: ApplyGamePassOperation,
	playerUserId: number,
	gamePassId: number,
}

export type OwnsGamePassResult = Result.Result<boolean, OwnsGamePassError>
export type ApplyGamePassResult = Result.Result<{}, ApplyGamePassError>

type GamePassHandler = (player: Player) -> any

local OWNS_GAME_PASS_OPERATION: OwnsGamePassOperation =
	'MonetizationService.OwnsGamePassAsync'
local APPLY_GAME_PASS_OPERATION: ApplyGamePassOperation =
	'MonetizationService.ApplyGamePassAsync'

local GamePasses = {}

function GamePasses.OwnsGamePassAsync(
	player: Player,
	gamePassId: number
): OwnsGamePassResult
	if GamePassCatalog[gamePassId] == nil then
		local errorPayload: OwnsGamePassError = {
			code = MonetizationErrors.UnknownGamePass,
			operation = OWNS_GAME_PASS_OPERATION,
			playerUserId = player.UserId,
			gamePassId = gamePassId,
		}

		return Result.Err(errorPayload)
	end

	local success, result = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(
			player.UserId,
			gamePassId
		)
	end)

	if not success then
		local errorPayload: OwnsGamePassError = {
			code = MonetizationErrors.GamePassOwnershipCheckFailed,
			operation = OWNS_GAME_PASS_OPERATION,
			playerUserId = player.UserId,
			gamePassId = gamePassId,
			cause = tostring(result),
		}

		return Result.Err(errorPayload)
	end

	return Result.Ok(result)
end

function GamePasses.ApplyGamePassAsync(
	player: Player,
	gamePassId: number
): ApplyGamePassResult
	local gamePassDefinition = GamePassCatalog[gamePassId]

	if gamePassDefinition == nil then
		local errorPayload: ApplyGamePassError = {
			code = MonetizationErrors.UnknownGamePass,
			operation = APPLY_GAME_PASS_OPERATION,
			playerUserId = player.UserId,
			gamePassId = gamePassId,
		}

		return Result.Err(errorPayload)
	end

	local callbackResult = (gamePassDefinition.Callback :: GamePassHandler)(
		player
	)

	if not callbackResult.ok then
		local errorPayload: ApplyGamePassError = {
			code = MonetizationErrors.GamePassGrantFailed,
			operation = APPLY_GAME_PASS_OPERATION,
			playerUserId = player.UserId,
			gamePassId = gamePassId,
			cause = tostring(callbackResult.error.code),
		}

		return Result.Err(errorPayload)
	end

	return Result.Ok {}
end

return table.freeze(GamePasses)
