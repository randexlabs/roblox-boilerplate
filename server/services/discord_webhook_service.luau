export type EmbedField = {
	name: string,
	value: string,
	inline: boolean?,
}

export type EmbedFooter = {
	text: string,
	icon_url: string?,
}

export type EmbedImage = {
	url: string,
}

export type EmbedThumbnail = {
	url: string,
}

export type EmbedAuthor = {
	name: string,
	url: string?,
	icon_url: string?,
}

export type Embed = {
	title: string?,
	type: string?,
	description: string?,
	url: string?,
	timestamp: string?,
	color: number?,
	footer: EmbedFooter?,
	image: EmbedImage?,
	thumbnail: EmbedThumbnail?,
	author: EmbedAuthor?,
	fields: { EmbedField }?,
}

export type AllowedMentions = {
	parse: { string }?,
	roles: { string }?,
	users: { string }?,
	replied_user: boolean?,
}

export type Button = {
	type: number,
	label: string?,
	style: number,
	custom_id: string?,
	url: string?,
	disabled: boolean?,
}

export type ActionRow = {
	type: number,
	components: { Button },
}

export type WebhookPayload = {
	content: string?,
	username: string?,
	avatar_url: string?,
	tts: boolean?,
	embeds: { Embed }?,
	allowed_mentions: AllowedMentions?,
	components: { ActionRow }?,
}

export type SendRequest = {
	WebhookUrl: string,
	Payload: WebhookPayload,
}

export type SendSuccess = {
	ResponseBody: string,
}

export type SendOperation = 'discord_webhook_service.send_async'

export type SendDiagnosticContext = {
	HasContent: boolean,
	HasEmbeds: boolean,
	HasComponents: boolean,
}

local HttpService = game:GetService 'HttpService'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local result = require(ReplicatedStorage.shared.result)
local webhook_errors = require(ReplicatedStorage.errors.webhook_errors)

export type SendErrorCode = webhook_errors.WebhookErrorCode
export type SendError = result.Error<SendErrorCode> & {
	operation: SendOperation,
	context: SendDiagnosticContext?,
}
export type SendResult = result.Result<SendSuccess, SendError>

local SEND_OPERATION: SendOperation = 'discord_webhook_service.send_async'

local discord_webhook_service = {}

local function has_payload_content(payload: WebhookPayload): boolean
	return payload.content ~= nil
		or payload.embeds ~= nil
		or payload.components ~= nil
end

local function get_send_diagnostic_context(
	payload: WebhookPayload
): SendDiagnosticContext
	return {
		HasContent = payload.content ~= nil,
		HasEmbeds = payload.embeds ~= nil,
		HasComponents = payload.components ~= nil,
	}
end

function discord_webhook_service.send_async(request: SendRequest): SendResult
	if request.WebhookUrl == '' then
		local error_payload: SendError = {
			code = webhook_errors.MissingWebhookUrl,
			operation = SEND_OPERATION,
		}

		return result.err(error_payload)
	end

	if not has_payload_content(request.Payload) then
		local error_payload: SendError = {
			code = webhook_errors.EmptyWebhookPayload,
			operation = SEND_OPERATION,
			context = get_send_diagnostic_context(request.Payload),
		}

		return result.err(error_payload)
	end

	local success, response_body = pcall(function()
		return HttpService:PostAsync(
			request.WebhookUrl,
			HttpService:JSONEncode(request.Payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not success then
		local error_payload: SendError = {
			code = webhook_errors.WebhookRequestFailed,
			operation = SEND_OPERATION,
			context = get_send_diagnostic_context(request.Payload),
			cause = tostring(response_body),
		}

		return result.err(error_payload)
	end

	return result.ok {
		ResponseBody = response_body,
	}
end

return table.freeze(discord_webhook_service)
