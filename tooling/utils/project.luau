local fs = require('@lune/fs')
local serde = require('@lune/serde')

export type Project = {
	start_place_id: number,
}

local m = {}

function m.read()
	local project_file = fs.readFile('project.toml')
	return serde.decode('toml', project_file) :: Project
end

function m.update_start_place_id(id: number)
	local project = m.read() :: Project
	project.start_place_id = id
	project = serde.encode('toml', project) :: any
	fs.writeFile('project.toml', project :: any)
end

return m
