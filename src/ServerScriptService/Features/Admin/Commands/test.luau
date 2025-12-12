local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Conch = require(ReplicatedStorage.Packages.Conch)

return function()
	Conch.register('hello', {
		permissions = { 'Dev' },
		arguments = function()
			return Conch.args.any()
		end,
		callback = function()
			local ctx = Conch.get_command_context() :: any
			print(`Hello {ctx.executor.player.Name}`)
		end,
	})
end
