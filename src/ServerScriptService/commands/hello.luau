local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local conch = require(ReplicatedStorage.pkg.conch)

conch.register('hello', {
	description = 'Greets the user running the command',
	permissions = {},
	arguments = function() end,
	callback = function(...)
		local command_context = conch.get_command_context()
		if command_context == nil then
			error 'hello must run inside a command context'
		end

		local typed_command_context = command_context :: {
			executor: {
				name: string,
			},
		}
		local username = typed_command_context.executor.name

		conch.log('normal', `Hello {username}!`)
	end,
})

return true
