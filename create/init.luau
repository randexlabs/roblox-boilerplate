local fs = require '@std/fs'
local io = require '@std/io'
local process = require '@std/process'
local tint = require '@luaupkg/tint'

local function has_dry_run()
	for _, arg in process.args do
		if arg == '--dry-run' then return true end
	end

	return false
end

local function destroy_dot_git()
	if not fs.exists '.git' or fs.type '.git' ~= 'dir' then return end
	fs.removeDirectory('.git', { recursive = true })
	process.run({ 'git', 'branch', '-M', 'main' }, { stdio = 'inherit' })
end

local function self_delete()
	if not fs.exists '.create' or fs.type '.create' ~= 'dir' then return end
	fs.removeDirectory('.create', { recursive = true })
end

local function initiate_git_repository()
	process.run({ 'git', 'init' }, { stdio = 'inherit' })
	process.run({ 'git', 'branch', '-M', 'main' }, { stdio = 'inherit' })
end

local function print_plan()
	print(`{tint.cyan 'dry-run:'} would remove .git if it exists`)
	print(`{tint.cyan 'dry-run:'} would initialize a new git repository`)
	print(`{tint.cyan 'dry-run:'} would remove .create if it exists`)
end

local function confirm()
	print(
		`{tint.yellow.bold 'WARNING:'} this will permanently remove {tint.red.bold '.git'} and reset repository history.`
	)

	local confirmations_required = 3

	for confirmed = 1, confirmations_required do
		local progress = tint.cyan(`({confirmed}/{confirmations_required})`)
		local answer = io.input(
			`{tint.yellow 'Continue and delete .git? '} {progress}{tint.yellow ' [y/N] '}`
		)
		answer = (answer:match '^%s*(.-)%s*$' or ''):lower()
		if answer ~= 'y' and answer ~= 'yes' then return false end
	end

	return true
end

if has_dry_run() then
	print_plan()
	return
end

if not confirm() then
	print(tint.red 'Aborted.')
	return
end

destroy_dot_git()
initiate_git_repository()
self_delete()
