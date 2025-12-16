local fs = require('@lune/fs')
local process = require('@lune/process')

local function destroy_dot_git()
	if not fs.isDir('.git') then return end
	fs.removeDir('.git')
end

local function self_delete()
	if fs.isDir('.create') then fs.removeDir('.create') end
end

local function initiate_git_repository()
	process.exec('git', { 'init' }, { stdio = 'forward' })
	process.exec('git', { 'branch', '-M', 'main' }, { stdio = 'forward' })
end

destroy_dot_git()
initiate_git_repository()
self_delete()
