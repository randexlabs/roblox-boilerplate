export type WebhookErrorCode =
	'MissingWebhookUrl'
	| 'EmptyWebhookPayload'
	| 'WebhookRequestFailed'

type WebhookErrors = {
	MissingWebhookUrl: WebhookErrorCode,
	EmptyWebhookPayload: WebhookErrorCode,
	WebhookRequestFailed: WebhookErrorCode,
}

local webhook_errors: WebhookErrors = {
	MissingWebhookUrl = 'MissingWebhookUrl',
	EmptyWebhookPayload = 'EmptyWebhookPayload',
	WebhookRequestFailed = 'WebhookRequestFailed',
}

return table.freeze(webhook_errors)
