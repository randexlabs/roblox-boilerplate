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

export type send_traits = {
	url: string,
	payload: webhook_payload,
}

local HttpService = game:GetService 'HttpService'

local DiscordWebhookService = {}

local function has_payload_content(payload: webhook_payload): boolean
	return payload.content ~= nil
		or payload.embeds ~= nil
		or payload.components ~= nil
end

function DiscordWebhookService:Send(
	send_traits: send_traits
): (boolean, string?)
	if send_traits.url == '' then return false, 'webhook url is required' end

	if not has_payload_content(send_traits.payload) then
		return false,
			'webhook payload must include content, embeds, or components'
	end

	local ok, result = pcall(function()
		return HttpService:PostAsync(
			send_traits.url,
			HttpService:JSONEncode(send_traits.payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if ok then return true, result end

	return false, result
end

return table.freeze(DiscordWebhookService)
