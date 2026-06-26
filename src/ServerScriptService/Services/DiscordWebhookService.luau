export type embed_field = {
	name: string,
	value: string,
	inline: boolean?,
}

export type embed_footer = {
	text: string,
	icon_url: string?,
}

export type embed_image = {
	url: string,
}

export type embed_thumbnail = {
	url: string,
}

export type embed_author = {
	name: string,
	url: string?,
	icon_url: string?,
}

export type embed = {
	title: string?,
	type: string?,
	description: string?,
	url: string?,
	timestamp: string?,
	color: number?,
	footer: embed_footer?,
	image: embed_image?,
	thumbnail: embed_thumbnail?,
	author: embed_author?,
	fields: { embed_field }?,
}

export type allowed_mentions = {
	parse: { string }?,
	roles: { string }?,
	users: { string }?,
	replied_user: boolean?,
}

export type button = {
	type: number,
	label: string?,
	style: number,
	custom_id: string?,
	url: string?,
	disabled: boolean?,
}

export type action_row = {
	type: number,
	components: { button },
}

export type webhook_payload = {
	content: string?,
	username: string?,
	avatar_url: string?,
	tts: boolean?,
	embeds: { embed }?,
	allowed_mentions: allowed_mentions?,
	components: { action_row }?,
}

export type send_request = {
	url: string,
	payload: webhook_payload,
}

export type send_success = {
	response_body: string,
}

export type send_error_code =
	'MissingWebhookUrl'
	| 'EmptyWebhookPayload'
	| 'WebhookRequestFailed'

local HttpService = game:GetService 'HttpService'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local Result = require(ReplicatedStorage.Shared.Result)

export type send_error = Result.Error<send_error_code>

local DiscordWebhookService = {}

local function has_payload_content(payload: webhook_payload): boolean
	return payload.content ~= nil
		or payload.embeds ~= nil
		or payload.components ~= nil
end

function DiscordWebhookService:Send(
	request: send_request
): (boolean, send_success | send_error)
	if request.url == '' then
		local error_payload: send_error = {
			code = 'MissingWebhookUrl',
			message = 'webhook url is required',
		}

		return Result.err(error_payload)
	end

	if not has_payload_content(request.payload) then
		local error_payload: send_error = {
			code = 'EmptyWebhookPayload',
			message = 'webhook payload must include content, embeds, or components',
		}

		return Result.err(error_payload)
	end

	local success, result = pcall(function()
		return HttpService:PostAsync(
			request.url,
			HttpService:JSONEncode(request.payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not success then
		local error_payload: send_error = {
			code = 'WebhookRequestFailed',
			message = 'discord webhook request failed',
			cause = tostring(result),
		}

		return Result.err(error_payload)
	end

	return Result.ok {
		response_body = result,
	}
end

return table.freeze(DiscordWebhookService)
