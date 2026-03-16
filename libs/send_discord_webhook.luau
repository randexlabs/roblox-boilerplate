local HttpService = game:GetService 'HttpService'

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

export type traits = {
	url: string,
	payload: webhook_payload,
}

return function(traits: traits): (boolean, string?)
	local ok, result = pcall(function()
		return HttpService:PostAsync(
			traits.url,
			HttpService:JSONEncode(traits.payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if ok then
		return true, result
	else
		return false, result
	end
end
