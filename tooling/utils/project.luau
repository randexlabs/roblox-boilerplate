local fs = require('@lune/fs')
local serde = require('@lune/serde')

export type Project = {
	start_place_id: number,
}

local project_file = fs.readFile('project.toml')
return serde.decode('toml', project_file) :: Project
