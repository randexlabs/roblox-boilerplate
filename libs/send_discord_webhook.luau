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

local is_roblox = if game then true else false

local function send_with_roblox(traits: traits): (boolean, string?)
	local http_service = game:GetService 'HttpService'
	local ok, result = pcall(function()
		return http_service:PostAsync(
			traits.url,
			http_service:JSONEncode(traits.payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if ok then return true, result end
	return false, result
end

local function send_with_lune(traits: traits): (boolean, string?)
	local net = require '@lune/net'
	local serde = require '@lune/serde'

	local request: net.FetchParams = {
		url = traits.url,
		method = 'POST',
		headers = {
			['Content-Type'] = 'application/json',
		} :: net.HttpHeaderMap,
		body = serde.encode('json', traits.payload),
	}

	local response = net.request(request)
	if response.ok then return true, response.body end
	return false, `{response.statusCode} {response.statusMessage}`
end

return function(traits: traits): (boolean, string?)
	if is_roblox then return send_with_roblox(traits) end
	return send_with_lune(traits)
end
