local MarketplaceService = game:GetService 'MarketplaceService'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local DeveloperProducts = require(script.DeveloperProducts)
local GamePasses = require(script.GamePasses)
local MonetizationErrors = require(ReplicatedStorage.Errors.MonetizationErrors)

export type MonetizationErrorCode = MonetizationErrors.MonetizationErrorCode
export type ReceiptInfo = DeveloperProducts.ReceiptInfo
export type ReceiptError = DeveloperProducts.ReceiptError
export type ReceiptSuccess = DeveloperProducts.ReceiptSuccess
export type ReceiptResult = DeveloperProducts.ReceiptResult
export type OwnsGamePassOperation = GamePasses.OwnsGamePassOperation
export type OwnsGamePassError = GamePasses.OwnsGamePassError
export type OwnsGamePassResult = GamePasses.OwnsGamePassResult
export type ApplyGamePassOperation = GamePasses.ApplyGamePassOperation
export type ApplyGamePassError = GamePasses.ApplyGamePassError
export type ApplyGamePassResult = GamePasses.ApplyGamePassResult

local hasStarted = false

local MonetizationService = {}

local function processReceipt(
	receiptInfo: ReceiptInfo
): Enum.ProductPurchaseDecision
	local ok, receiptResult =
		pcall(DeveloperProducts.HandleReceiptAsync, receiptInfo)

	if not ok then
		warn(
			`[MonetizationService] code={MonetizationErrors.DeveloperProductGrantFailed} playerUserId={receiptInfo.PlayerId} productId={receiptInfo.ProductId} purchaseId={receiptInfo.PurchaseId} cause={tostring(
				receiptResult
			)}`
		)

		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	if not receiptResult.ok then
		DeveloperProducts.WarnReceiptError(receiptResult.error)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	return receiptResult.value.Decision
end

function MonetizationService.Start()
	assert(not hasStarted, 'MonetizationService.Start must only be called once')

	hasStarted = true
	MarketplaceService.ProcessReceipt = processReceipt
end

function MonetizationService.OwnsGamePassAsync(
	player: Player,
	gamePassId: number
): OwnsGamePassResult
	return GamePasses.OwnsGamePassAsync(player, gamePassId)
end

function MonetizationService.ApplyGamePassAsync(
	player: Player,
	gamePassId: number
): ApplyGamePassResult
	return GamePasses.ApplyGamePassAsync(player, gamePassId)
end

return table.freeze(MonetizationService)
