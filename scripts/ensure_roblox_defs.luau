local fs = require '@lune/fs'
local net = require '@lune/net'

local function touch_file(path: string)
	local body = fs.readFile(path)
	fs.writeFile(path, body)
end

local function ensure_file(path: string, url: string)
	if fs.isFile(path) then
		touch_file(path)
		return
	end

	local tmp_path = `{path}.tmp`
	if fs.isFile(tmp_path) then fs.removeFile(tmp_path) end

	local res = net.request {
		url = url,
		method = 'GET',
	}

	if res.statusCode ~= 200 then
		error(`failed to download {url} (status {res.statusCode})`)
	end

	fs.writeFile(tmp_path, res.body)
	fs.move(tmp_path, path)
end

ensure_file(
	'globalTypes.d.luau',
	'https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/refs/heads/main/scripts/globalTypes.d.luau'
)
ensure_file(
	'vectorTypes.d.luau',
	'https://gist.githubusercontent.com/ernisto/3b0e3513700e20ccf8011efc77de234e/raw/9420d321050dad03f25b794e0c2e64673f78da57/vector.d.luau'
)
