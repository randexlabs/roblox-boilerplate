# Blink

An IDL compiler written in Luau for ROBLOX buffer networking.

## Performance

Blink aims to generate code that is bandwidth-efficient for your specific experience:

- Lower bandwidth usage (often lower ping)
- Lower CPU usage compared to more generalized networking solutions

Note: compared to standard ROBLOX networking, results may vary, but Blink should not increase ping.

## Security

Blink focuses on two defenses:

- Client-sent data is validated on the receiving side before reaching critical game code
- Compression makes it harder to snoop network traffic (e.g., via RemoteSpy-style tools)

## Get started

This guide targets CLI usage (syntax also applies to the Studio plugin).

### Write your first network description

Create a `.blink` file and paste an example:

```blink
option ClientOutput = "path/to/client.luau"
option ServerOutput = "path/to/server.luau"

event MyFirstEvent {
  from: Server,
  type: Reliable,
  call: SingleSync,
  data: string
}
```

### Compile

From the directory containing the file:

```bash
blink FILE_NAME
```

This generates the configured Luau outputs (client/server).

### Use generated code

Server:

```lua
local Net = require(Path.To.Server)
Net.MyFirstEvent.FireAll("Hello World")
```

Client:

```lua
local Net = require(Path.To.Client)
Net.MyFirstEvent.On(function(text)
	print(text)
end)
```

## CLI

### Compile descriptions

```bash
blink file-name
```

Blink searches for `file-name.blink` (or `file-name.txt`) in the current directory.

### Watch mode

```bash
blink file-name --watch
```

Watches the target file and all transitive imports; recompiles on change.

## Language reference

- `language/index.md`: index of the Blink language/reference docs
