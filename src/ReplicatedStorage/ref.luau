--!optimize 2

-- MIT License

-- Copyright (c) 2025 replecs authors

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local Jecs = require(ReplicatedStorage.packages.jecs)
local world = require(ReplicatedStorage.world)
local refs: { [any]: any } = {}

--- Gets an entity the given key references to.
--- If the key is nil, an entirely new entity is created and returned.
--- If the key doesn't reference an entity, a new entity is made for it to reference and returned.
--- @param key any
local function ref(
	key: any,
	initer: ((entity: Jecs.Entity) -> ())?
): Jecs.Entity
	if not key then return world:entity() end

	local entity = refs[key]
	if not entity then
		entity = world:entity()

		if initer then initer(entity) end

		refs[key] = entity
	end

	return entity
end

-- For the `__call`` metamethod
local function __call(_, key: any, initer: (entity: Jecs.Entity) -> ())
	return ref(key, initer)
end

local function search(key: any)
	if not key then return nil end
	local entity = refs[key]

	if not entity then return nil end

	return entity
end

function set(key: any, entity: Jecs.Entity)
	refs[key] = entity
end

function unlist(key: any)
	if not key then return end
	refs[key] = nil
end

local metatable = {
	__call = __call,
}

local lib = {
	set = set,
	search = search,
	unlist = unlist,
}

local REF = (
		setmetatable :: any
	)(lib, metatable) :: typeof(ref) & typeof(setmetatable(lib, metatable))

return REF
