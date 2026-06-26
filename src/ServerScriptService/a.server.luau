local DiscordWebhookService =
	require(script.Parent.Services.DiscordWebhookService)

local webhook_url =
	'https://discord.com/api/webhooks/1478597004518232076/jESzlvcX558yxZ5mLda7Oa1EKMANkPOB2yDpqYXEbWjS9PX-dqMJCWvGSPJeUNlvYLfi'

local ok, result = DiscordWebhookService:Send {
	url = webhook_url,
	payload = {
		content = 'test message from a.server.luau',
		username = 'rb test',
	},
}

if not ok then warn(result) end
