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

exec('rojo', { 'build', '-o', 'game.rbxl' }, { stdio = 'forward' })
exec('start', { 'game.rbxl' }, { stdio = 'forward', shell = true })
