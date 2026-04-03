# Standard Library

High-value built-in modules used in repo scripts:

- `@lune/fs`: filesystem access. See `api/fs.md`
- `@lune/net`: HTTP, servers, sockets, TCP. See `api/net.md`
- `@lune/process`: args, spawning, exec. See `api/process.md`
- `@lune/serde`: encoding, decoding, compression, hashing. See `api/serde.md`
- `@lune/stdio`: prompts and console I/O. See `api/stdio.md`
- `@lune/task`: scheduler primitives. See `api/task.md`
- `@lune/regex`: regex API. See `api/regex.md`

## Import pattern

```luau
local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")
```
