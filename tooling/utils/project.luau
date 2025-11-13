local fs = require('@lune/fs')
local toml = require('../vendor/toml')

export type Project = {
	start_place_id: number,
}

local project_file = fs.readFile('project.toml')
return toml.deserialize(project_file) :: Project
