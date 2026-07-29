local Players = game:GetService 'Players'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local ServerScriptService = game:GetService 'ServerScriptService'

local monetization_errors =
	require(ReplicatedStorage.errors.monetization_errors)
local product_catalog = require(ServerScriptService.products)
local profile_store_service =
	require(ServerScriptService.services.profile_store_service)
local result = require(ReplicatedStorage.shared.result)

export type MonetizationErrorCode = monetization_errors.MonetizationErrorCode
export type ReceiptInfo = {
	PlayerId: number,
	ProductId: number,
	PurchaseId: string,
}
export type ReceiptOperation =
	'monetization_service.handle_developer_product_receipt_async'
export type ReceiptError = result.Error<MonetizationErrorCode> & {
	operation: ReceiptOperation,
	playerUserId: number,
	productId: number,
	purchaseId: string,
}
export type ReceiptSuccess = {
	Decision: Enum.ProductPurchaseDecision,
}
export type ReceiptResult = result.Result<ReceiptSuccess, ReceiptError>

type PlayerProfileData = profile_store_service.PlayerProfileData
type PlayerProfile = profile_store_service.PlayerProfile
type DeveloperProductHandler = (
	player: Player,
	receipt_info: ReceiptInfo
) -> any

local RECEIPT_OPERATION: ReceiptOperation =
	'monetization_service.handle_developer_product_receipt_async'

local developer_products = {}

local function get_processed_purchase_ids(profile_data: any): {
	[string]: boolean,
}
	local processed_purchase_ids = profile_data.ProcessedPurchaseIds

	if processed_purchase_ids == nil then return {} end

	return processed_purchase_ids
end

local function get_receipt_error(
	receipt_info: ReceiptInfo,
	code: MonetizationErrorCode,
	cause: string?
): ReceiptError
	return {
		code = code,
		operation = RECEIPT_OPERATION,
		playerUserId = receipt_info.PlayerId,
		productId = receipt_info.ProductId,
		purchaseId = receipt_info.PurchaseId,
		cause = cause,
	}
end

function developer_products.warn_receipt_error(error_payload: ReceiptError)
	local cause_text = ''

	if error_payload.cause ~= nil then
		cause_text = ` cause={error_payload.cause}`
	end

	warn(
		`[monetization_service] code={error_payload.code} operation={error_payload.operation} playerUserId={error_payload.playerUserId} productId={error_payload.productId} purchaseId={error_payload.purchaseId}{cause_text}`
	)
end

function developer_products.handle_receipt_async(
	receipt_info: ReceiptInfo
): ReceiptResult
	local player = Players:GetPlayerByUserId(receipt_info.PlayerId)

	if player == nil then
		return result.err(
			get_receipt_error(
				receipt_info,
				monetization_errors.ReceiptPlayerNotFound
			)
		)
	end

	local profile_result = profile_store_service.wait_for_profile_async(player)

	if not profile_result.ok then
		return result.err(
			get_receipt_error(
				receipt_info,
				monetization_errors.ReceiptProfileLoadFailed,
				tostring(profile_result.error.code)
			)
		)
	end

	if player.Parent ~= Players then
		return result.err(
			get_receipt_error(
				receipt_info,
				monetization_errors.ReceiptPlayerLeftBeforeProfileReady
			)
		)
	end

	local profile = profile_result.value :: PlayerProfile
	local saved_profile_data = profile.LastSavedData :: PlayerProfileData
	local saved_processed_purchase_ids =
		get_processed_purchase_ids(saved_profile_data)

	if saved_processed_purchase_ids[receipt_info.PurchaseId] then
		return result.ok {
			Decision = Enum.ProductPurchaseDecision.PurchaseGranted,
		}
	end

	local current_profile_data = profile.Data :: PlayerProfileData
	local current_processed_purchase_ids =
		get_processed_purchase_ids(current_profile_data)

	local product_definition = product_catalog[receipt_info.ProductId]

	if
		product_definition == nil
		and not current_processed_purchase_ids[receipt_info.PurchaseId]
	then
		return result.err(
			get_receipt_error(
				receipt_info,
				monetization_errors.UnknownDeveloperProduct
			)
		)
	end

	if not current_processed_purchase_ids[receipt_info.PurchaseId] then
		local callback_result = (
			product_definition.Callback :: DeveloperProductHandler
		)(player, receipt_info)

		if not callback_result.ok then
			return result.err(
				get_receipt_error(
					receipt_info,
					monetization_errors.DeveloperProductGrantFailed,
					tostring(callback_result.error.code)
				)
			)
		end

		current_processed_purchase_ids[receipt_info.PurchaseId] = true
	end

	local save_result = profile_store_service.save_profile_async(player)

	if not save_result.ok then
		return result.err(
			get_receipt_error(
				receipt_info,
				monetization_errors.ReceiptProfileSaveFailed,
				tostring(save_result.error.code)
			)
		)
	end

	local latest_saved_profile_data = profile.LastSavedData :: PlayerProfileData
	local latest_saved_processed_purchase_ids =
		get_processed_purchase_ids(latest_saved_profile_data)

	if not latest_saved_processed_purchase_ids[receipt_info.PurchaseId] then
		return result.err(
			get_receipt_error(
				receipt_info,
				monetization_errors.ReceiptProfileSaveFailed,
				'PurchaseIdNotDurablyPersisted'
			)
		)
	end

	return result.ok {
		Decision = Enum.ProductPurchaseDecision.PurchaseGranted,
	}
end

return table.freeze(developer_products)
