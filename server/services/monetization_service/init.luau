local MarketplaceService = game:GetService 'MarketplaceService'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local developer_products = require(script.developer_products)
local game_passes = require(script.game_passes)
local monetization_errors =
	require(ReplicatedStorage.errors.monetization_errors)

export type MonetizationErrorCode = monetization_errors.MonetizationErrorCode
export type ReceiptInfo = developer_products.ReceiptInfo
export type ReceiptError = developer_products.ReceiptError
export type ReceiptSuccess = developer_products.ReceiptSuccess
export type ReceiptResult = developer_products.ReceiptResult
export type OwnsGamePassOperation = game_passes.OwnsGamePassOperation
export type OwnsGamePassError = game_passes.OwnsGamePassError
export type OwnsGamePassResult = game_passes.OwnsGamePassResult
export type ApplyGamePassOperation = game_passes.ApplyGamePassOperation
export type ApplyGamePassError = game_passes.ApplyGamePassError
export type ApplyGamePassResult = game_passes.ApplyGamePassResult

local has_started = false

local monetization_service = {}

local function process_receipt(
	receipt_info: ReceiptInfo
): Enum.ProductPurchaseDecision
	local ok, receipt_result =
		pcall(developer_products.handle_receipt_async, receipt_info)

	if not ok then
		warn(
			`[monetization_service] code={monetization_errors.DeveloperProductGrantFailed} playerUserId={receipt_info.PlayerId} productId={receipt_info.ProductId} purchaseId={receipt_info.PurchaseId} cause={tostring(
				receipt_result
			)}`
		)

		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	if not receipt_result.ok then
		developer_products.warn_receipt_error(receipt_result.error)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	return receipt_result.value.Decision
end

function monetization_service.start()
	assert(
		not has_started,
		'monetization_service.start must only be called once'
	)

	has_started = true
	MarketplaceService.ProcessReceipt = process_receipt
end

function monetization_service.owns_game_pass_async(
	player: Player,
	game_pass_id: number
): OwnsGamePassResult
	return game_passes.owns_game_pass_async(player, game_pass_id)
end

function monetization_service.apply_game_pass_async(
	player: Player,
	game_pass_id: number
): ApplyGamePassResult
	return game_passes.apply_game_pass_async(player, game_pass_id)
end

return table.freeze(monetization_service)
