local cleanup = if game
	then require(script.Parent.cleanup)
	else require './cleanup'

local function deleted_err()
	error('Cannot use pool after destroy.', 2)
end

return function<obj>()
	local strict = false
	local constructor = nil

	local stack = {} :: { obj }
	local exports = {}
	type self = typeof(exports)

	function exports.register_constructor<T>(self: self, fn: () -> obj)
		constructor = fn
		return exports
	end

	function exports.preallocate(self: self, size: number)
		assert(typeof(constructor) == 'function')

		for i = 1, size do
			table.insert(stack, constructor())
		end

		return exports
	end

	function exports.get(self: self): obj?
		if #stack > 0 then return table.remove(stack) end
		if not strict and constructor then return constructor() end
		return nil
	end

	function exports.release(self: self, obj: obj)
		table.insert(stack, obj)
	end

	function exports.size(self: self): number
		return #stack
	end

	function exports.destroy(self: self)
		for index in exports do
			exports[index] = nil
		end

		setmetatable(exports, { __index = deleted_err })

		for _, obj in stack do
			cleanup(obj, 3)
		end

		stack = nil :: any
		constructor = nil :: any
		strict = nil :: any
	end

	function exports.enable_strict(self: self)
		strict = true
		return self
	end

	return exports
end
