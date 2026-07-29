local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local ServerScriptService = game:GetService 'ServerScriptService'

local MonetizationErrors = require(ReplicatedStorage.Errors.MonetizationErrors)
local ProductCatalog = require(ServerScriptService.Products)
local ProfileStoreService =
	require(ServerScriptService.Services.ProfileStoreService)
local Result = require(ReplicatedStorage.Shared.Result)

export type MonetizationErrorCode = MonetizationErrors.MonetizationErrorCode
export type ReceiptInfo = {
	PlayerId: number,
	ProductId: number,
	PurchaseId: string,
}
export type ReceiptOperation =
	'MonetizationService.HandleDeveloperProductReceiptAsync'
export type ReceiptError = Result.Error<MonetizationErrorCode> & {
	operation: ReceiptOperation,
	playerUserId: number,
	productId: number,
	purchaseId: string,
}
export type ReceiptSuccess = {
	Decision: Enum.ProductPurchaseDecision,
}
export type ReceiptResult = Result.Result<ReceiptSuccess, ReceiptError>

type PlayerProfileData = ProfileStoreService.PlayerProfileData
type PlayerProfile = ProfileStoreService.PlayerProfile
type DeveloperProductHandler = (player: Player, receiptInfo: ReceiptInfo) -> any

local RECEIPT_OPERATION: ReceiptOperation =
	'MonetizationService.HandleDeveloperProductReceiptAsync'

local DeveloperProducts = {}

local function getProcessedPurchaseIds(profileData: any): {
	[string]: boolean,
}
	local processedPurchaseIds = profileData.ProcessedPurchaseIds

	if processedPurchaseIds == nil then return {} end

	return processedPurchaseIds
end

local function getReceiptError(
	receiptInfo: ReceiptInfo,
	code: MonetizationErrorCode,
	cause: string?
): ReceiptError
	return {
		code = code,
		operation = RECEIPT_OPERATION,
		playerUserId = receiptInfo.PlayerId,
		productId = receiptInfo.ProductId,
		purchaseId = receiptInfo.PurchaseId,
		cause = cause,
	}
end

function DeveloperProducts.WarnReceiptError(errorPayload: ReceiptError)
	local causeText = ''

	if errorPayload.cause ~= nil then
		causeText = ` cause={errorPayload.cause}`
	end

	warn(
		`[MonetizationService] code={errorPayload.code} operation={errorPayload.operation} playerUserId={errorPayload.playerUserId} productId={errorPayload.productId} purchaseId={errorPayload.purchaseId}{causeText}`
	)
end

function DeveloperProducts.HandleReceiptAsync(
	receiptInfo: ReceiptInfo
): ReceiptResult
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)

	if player == nil then
		return Result.Err(
			getReceiptError(
				receiptInfo,
				MonetizationErrors.ReceiptPlayerNotFound
			)
		)
	end

	local profileResult = ProfileStoreService.WaitForProfileAsync(player)

	if not profileResult.ok then
		return Result.Err(
			getReceiptError(
				receiptInfo,
				MonetizationErrors.ReceiptProfileLoadFailed,
				tostring(profileResult.error.code)
			)
		)
	end

	if player.Parent ~= Players then
		return Result.Err(
			getReceiptError(
				receiptInfo,
				MonetizationErrors.ReceiptPlayerLeftBeforeProfileReady
			)
		)
	end

	local profile = profileResult.value :: PlayerProfile
	local savedProfileData = profile.LastSavedData :: PlayerProfileData
	local savedProcessedPurchaseIds = getProcessedPurchaseIds(savedProfileData)

	if savedProcessedPurchaseIds[receiptInfo.PurchaseId] then
		return Result.Ok {
			Decision = Enum.ProductPurchaseDecision.PurchaseGranted,
		}
	end

	local currentProfileData = profile.Data :: PlayerProfileData
	local currentProcessedPurchaseIds =
		getProcessedPurchaseIds(currentProfileData)

	local productDefinition = ProductCatalog[receiptInfo.ProductId]

	if
		productDefinition == nil
		and not currentProcessedPurchaseIds[receiptInfo.PurchaseId]
	then
		return Result.Err(
			getReceiptError(
				receiptInfo,
				MonetizationErrors.UnknownDeveloperProduct
			)
		)
	end

	if not currentProcessedPurchaseIds[receiptInfo.PurchaseId] then
		local callbackResult = (
			productDefinition.Callback :: DeveloperProductHandler
		)(player, receiptInfo)

		if not callbackResult.ok then
			return Result.Err(
				getReceiptError(
					receiptInfo,
					MonetizationErrors.DeveloperProductGrantFailed,
					tostring(callbackResult.error.code)
				)
			)
		end

		currentProcessedPurchaseIds[receiptInfo.PurchaseId] = true
	end

	local saveResult = ProfileStoreService.SaveProfileAsync(player)

	if not saveResult.ok then
		return Result.Err(
			getReceiptError(
				receiptInfo,
				MonetizationErrors.ReceiptProfileSaveFailed,
				tostring(saveResult.error.code)
			)
		)
	end

	local latestSavedProfileData = profile.LastSavedData :: PlayerProfileData
	local latestSavedProcessedPurchaseIds =
		getProcessedPurchaseIds(latestSavedProfileData)

	if not latestSavedProcessedPurchaseIds[receiptInfo.PurchaseId] then
		return Result.Err(
			getReceiptError(
				receiptInfo,
				MonetizationErrors.ReceiptProfileSaveFailed,
				'PurchaseIdNotDurablyPersisted'
			)
		)
	end

	return Result.Ok {
		Decision = Enum.ProductPurchaseDecision.PurchaseGranted,
	}
end

return table.freeze(DeveloperProducts)
