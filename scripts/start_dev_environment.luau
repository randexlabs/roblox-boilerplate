local fs = require('@lune/fs')
local process = require('@lune/process')
local task = require('@lune/task')

local spawn = task.spawn
local exec = process.exec :: <T...>(T...) -> any

spawn(exec, 'rojo', { 'serve' }, { stdio = 'forward' })
spawn(
	exec,
	'rojo',
	{ 'sourcemap', '-o', 'sourcemap.json', '--watch' },
	{ stdio = 'forward' }
)

if not fs.isFile('game.rbxl') then
	warn(
		"Cannot find 'game.rbxl'. Please ensure the file exists before running the dev environment."
	)
	return
end

exec('start', { 'game.rbxl' }, { stdio = 'forward', shell = true })
