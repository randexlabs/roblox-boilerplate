# Guard clauses: Roblox/Luau use-cases

## Validate RemoteEvent/RemoteFunction inputs (server)

Client input is untrusted; validate early:

```luau
local function onVoteMap(player: Player, mapId: unknown)
	if type(mapId) ~= "string" then return end
	if #mapId == 0 then return end

	-- Optional: check authorization/availability before recording the vote.
end
```

## Ensure instances still exist

```luau
local function setBillboardText(billboard: BillboardGui?, text: string)
	if billboard == nil then return end
	if billboard.Parent == nil then return end

	local label = billboard:FindFirstChild("Label")
	if not label or not label:IsA("TextLabel") then return end

	label.Text = text
end
```

## Rate limiting / cooldowns

```luau
local function tryAction(now: number, nextAllowedAt: number): boolean
	if now < nextAllowedAt then
		return false
	end

	return true
end
```

