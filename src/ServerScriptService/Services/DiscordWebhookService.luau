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
	url: string,
	payload: WebhookPayload,
}

export type SendSuccess = {
	response_body: string,
}

export type SendOperation = 'DiscordWebhookService.SendAsync'

export type SendDiagnosticContext = {
	hasContent: boolean,
	hasEmbeds: boolean,
	hasComponents: boolean,
}

local HttpService = game:GetService 'HttpService'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local Result = require(ReplicatedStorage.Shared.Result)
local WebhookErrors = require(ReplicatedStorage.Errors.WebhookErrors)

export type SendErrorCode = WebhookErrors.WebhookErrorCode
export type SendError = Result.Error<SendErrorCode> & {
	operation: SendOperation,
	context: SendDiagnosticContext?,
}
export type SendResult = Result.Result<SendSuccess, SendError>

local SEND_OPERATION: SendOperation = 'DiscordWebhookService.SendAsync'

local DiscordWebhookService = {}

local function hasPayloadContent(payload: WebhookPayload): boolean
	return payload.content ~= nil
		or payload.embeds ~= nil
		or payload.components ~= nil
end

local function getSendDiagnosticContext(
	payload: WebhookPayload
): SendDiagnosticContext
	return {
		hasContent = payload.content ~= nil,
		hasEmbeds = payload.embeds ~= nil,
		hasComponents = payload.components ~= nil,
	}
end

function DiscordWebhookService.SendAsync(request: SendRequest): SendResult
	if request.url == '' then
		local errorPayload: SendError = {
			code = WebhookErrors.MissingWebhookUrl,
			operation = SEND_OPERATION,
		}

		return Result.Err(errorPayload)
	end

	if not hasPayloadContent(request.payload) then
		local errorPayload: SendError = {
			code = WebhookErrors.EmptyWebhookPayload,
			operation = SEND_OPERATION,
			context = getSendDiagnosticContext(request.payload),
		}

		return Result.Err(errorPayload)
	end

	local success, result = pcall(function()
		return HttpService:PostAsync(
			request.url,
			HttpService:JSONEncode(request.payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not success then
		local errorPayload: SendError = {
			code = WebhookErrors.WebhookRequestFailed,
			operation = SEND_OPERATION,
			context = getSendDiagnosticContext(request.payload),
			cause = tostring(result),
		}

		return Result.Err(errorPayload)
	end

	return Result.Ok {
		response_body = result,
	}
end

return table.freeze(DiscordWebhookService)
