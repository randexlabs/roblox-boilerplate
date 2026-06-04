# Getting Started

## Installation

### Wally

```toml
ldgerrits/quickzone@1.4.6
```

### npm / roblox-ts

```bash
npm i @rbxts/quickzone
```

### Manual model import

The docs describe a standalone model import workflow via releases and placement under shared game storage.

## Basic Require

```luau
local QuickZone = require(game:GetService("ReplicatedStorage").QuickZone)
local Zone, Group, Observer = QuickZone.Zone, QuickZone.Group, QuickZone.Observer
```

## Root Configuration

Typical startup configuration:

```luau
QuickZone:configure({
	enabled = true,
	autoSyncRate = 30,
	frameBudget = 1,
})
```

Interpretation:

- `enabled`: auto-run scheduler on or off
- `autoSyncRate`: how often auto-sync zones track references
- `frameBudget`: milliseconds per frame, even though the internal scheduler stores seconds

## Recommended First Pattern

The docs recommend the lifecycle approach first:

```luau
local players = Group.players()
local zones = Zone.fromTag("AntiGravity", {
	metadata = { GravityMultiplier = 0.4 }
})

local observer = Observer.new({
	groups = { players },
	zones = { zones },
})

observer:observePlayer(function(player, zone)
	-- setup on enter
	return function()
		-- cleanup on exit
	end
end)
```

Use it when logic has a real active/inactive lifetime.

## Other Supported Styles

- Event-driven: use `onEnter`, `onExit`, and transition signals.
- Polling / ECS: disable auto updates with `QuickZone:setEnabled(false)` and step `QuickZone:update(dt)` manually.

## Shared Groups And Shared Zones

The examples encourage centralizing shared groups and shared zones when multiple scripts need the same spatial substrate.

Reason:

- avoids duplicate setup
- keeps trees smaller
- lets multiple systems react to the same spatial topology
