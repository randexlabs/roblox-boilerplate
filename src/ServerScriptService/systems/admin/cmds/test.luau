local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local conch = require(ReplicatedStorage.pkg.conch)

return function()
	conch.register('hello', {
		permissions = { 'Dev' },
		arguments = function()
			return conch.args.any()
		end,
		callback = function()
			local ctx = conch.get_command_context() :: any
			print(`Hello {ctx.executor.player.Name}`)
		end,
	})
end
