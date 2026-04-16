local env = require '@lib/env'
local fs = require '@lune/fs'
local process = require '@lune/process'
local rocloud = require '@lunepkg/rocloud'
local task = require '@lune/task'

local auth = rocloud.auth
local luau_task_exec = rocloud.luau_task_exec
type luau_task_identity = rocloud.luau_task_identity

local API_KEY = env.str 'API_KEY' or error 'API_KEY missing'
local UNIVERSE_ID = env.num 'UNIVERSE_ID' or error 'UNIVERSE_ID missing'
local PLACE_ID = env.num 'PLACE_ID' or error 'PLACE_ID missing'
local PATH_TO_FILE = process.args[1] or error 'PATH_TO_FILE missing'
if not fs.isFile(PATH_TO_FILE) then error 'Invalid path' end

local session = auth.apikey.login(API_KEY)

local function create_task_async()
	local response = luau_task_exec.create(
		session,
		{ place_id = PLACE_ID, universe_id = UNIVERSE_ID },
		{ script = fs.readFile(PATH_TO_FILE) }
	)

	return if response.ok
		then response
		else error(`{response.code}: {response.message}`)
end

local function get_task_async(task_identity: luau_task_identity)
	local response = luau_task_exec.get(session, task_identity)
	return if response.ok
		then response
		else error(`{response.code}: {response.message}`)
end

local function get_task_logs_async(task_identity: luau_task_identity)
	local response = luau_task_exec.list_logs(session, task_identity, {
		view = 'FLAT',
	})

	return if response.ok
		then response
		else error(`{response.code}: {response.message}`)
end

local task_created = create_task_async()
local task_status

while task.wait(3) do
	task_status = get_task_async(task_created.body)
	assert(task_status.body)

	local state = task_status.body.state
	if state == 'COMPLETE' then break end
end

local logs = get_task_logs_async(task_created.body)
assert(logs.body)

for _, log in logs.body.luauExecutionSessionTaskLogs do
	for _, msg in log.messages do
		print(msg)
	end
end
