local fs = require('@std/fs')
local io = require('@std/io')
local process = require('@std/process')

local function has_dry_run()
	for _, arg in process.args do
		if arg == '--dry-run' then return true end
	end

	return false
end

local function destroy_dot_git()
	if not fs.exists('.git') or fs.type('.git') ~= 'dir' then return end
	fs.removeDirectory('.git', { recursive = true })
	process.run({ 'git', 'branch', '-M', 'main' }, { stdio = 'inherit' })
end

local function self_delete()
	if fs.exists('.create') and fs.type('.create') == 'dir' then
		fs.removeDirectory('.create', { recursive = true })
	end
end

local function initiate_git_repository()
	process.run({ 'git', 'init' }, { stdio = 'inherit' })
	process.run({ 'git', 'branch', '-M', 'main' }, { stdio = 'inherit' })
end

local function print_plan()
	print('dry-run: would remove .git if it exists')
	print('dry-run: would initialize a new git repository')
	print('dry-run: would remove .create if it exists')
end

local function confirm()
	print('WARNING: this will permanently remove .git and reset repository history.')
	local answer = string.lower(io.input('Continue? [y/N] '))
	return answer == 'y' or answer == 'yes'
end

if has_dry_run() then
	print_plan()
	return
end

if not confirm() then
	print('Aborted.')
	return
end

destroy_dot_git()
initiate_git_repository()
self_delete()
