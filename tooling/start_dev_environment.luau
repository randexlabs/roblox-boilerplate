local fs = require('@lune/fs')
local net = require('@lune/net')
local process = require('@lune/process')
local project = require('./utils/project')
local roblox = require('@lune/roblox')
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

local function start_place()
	exec('start', { 'game.rbxl' }, { stdio = 'forward', shell = true })
end

if fs.isFile('game.rbxl') then
	start_place()
	return
end

local place_id = project.start_place_id
local cookie = roblox.getAuthCookie()
assert(cookie, 'Failed to get auth cookie')

local result = net.request {
	url = 'https://assetdelivery.roblox.com/v1/asset/',
	headers = { Cookie = cookie },
	query = { id = tostring(place_id) },
}

assert(result.ok, result.body)

fs.writeFile('game.rbxl', result.body)
start_place()
