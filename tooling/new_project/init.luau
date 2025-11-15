local fs = require('@lune/fs')

local function destroy_dot_git()
	if not fs.isDir('.git') then return end
	fs.removeDir('.git')
end

local function self_delete()
	if not fs.isDir('new_project') then return end
	fs.removeDir('new_project')
end

destroy_dot_git()
self_delete()
