local fs = require('@lune/fs')
local process = require('@lune/process')

local function destroy_dot_git()
	if not fs.isDir('.git') then return end
	fs.removeDir('.git')
end

local function self_delete()
	if not fs.isDir('new_project') then return end
	fs.removeDir('new_project')
end

local function initiate_git_repository()
	process.exec('git', { 'init' }, { stdio = 'forward' })
end

destroy_dot_git()
initiate_git_repository()
self_delete()
