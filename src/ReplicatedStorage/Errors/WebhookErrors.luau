export type WebhookErrorCode =
	'MissingWebhookUrl'
	| 'EmptyWebhookPayload'
	| 'WebhookRequestFailed'

type WebhookErrors = {
	MissingWebhookUrl: WebhookErrorCode,
	EmptyWebhookPayload: WebhookErrorCode,
	WebhookRequestFailed: WebhookErrorCode,
}

local WebhookErrors: WebhookErrors = {
	MissingWebhookUrl = 'MissingWebhookUrl',
	EmptyWebhookPayload = 'EmptyWebhookPayload',
	WebhookRequestFailed = 'WebhookRequestFailed',
}

return table.freeze(WebhookErrors)
