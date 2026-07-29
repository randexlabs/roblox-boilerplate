export type MonetizationErrorCode =
	'UnknownGamePass'
	| 'GamePassOwnershipCheckFailed'
	| 'GamePassGrantFailed'
	| 'ReceiptPlayerNotFound'
	| 'ReceiptPlayerLeftBeforeProfileReady'
	| 'ReceiptProfileLoadFailed'
	| 'ReceiptProfileSaveFailed'
	| 'UnknownDeveloperProduct'
	| 'DeveloperProductGrantFailed'

type MonetizationErrors = {
	UnknownGamePass: MonetizationErrorCode,
	GamePassOwnershipCheckFailed: MonetizationErrorCode,
	GamePassGrantFailed: MonetizationErrorCode,
	ReceiptPlayerNotFound: MonetizationErrorCode,
	ReceiptPlayerLeftBeforeProfileReady: MonetizationErrorCode,
	ReceiptProfileLoadFailed: MonetizationErrorCode,
	ReceiptProfileSaveFailed: MonetizationErrorCode,
	UnknownDeveloperProduct: MonetizationErrorCode,
	DeveloperProductGrantFailed: MonetizationErrorCode,
}

local monetization_errors: MonetizationErrors = {
	UnknownGamePass = 'UnknownGamePass',
	GamePassOwnershipCheckFailed = 'GamePassOwnershipCheckFailed',
	GamePassGrantFailed = 'GamePassGrantFailed',
	ReceiptPlayerNotFound = 'ReceiptPlayerNotFound',
	ReceiptPlayerLeftBeforeProfileReady = 'ReceiptPlayerLeftBeforeProfileReady',
	ReceiptProfileLoadFailed = 'ReceiptProfileLoadFailed',
	ReceiptProfileSaveFailed = 'ReceiptProfileSaveFailed',
	UnknownDeveloperProduct = 'UnknownDeveloperProduct',
	DeveloperProductGrantFailed = 'DeveloperProductGrantFailed',
}

return table.freeze(monetization_errors)
