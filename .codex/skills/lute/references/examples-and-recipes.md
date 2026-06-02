# Examples and Recipes

This file reorganizes the local `examples/` directory into practical workflows. Use it to answer “how do I actually use this?” questions after the API surface is already clear.

## Cross-Cutting Caveat

Many examples use `@std/...` wrappers rather than the lower-level `@lute/...` runtime APIs.

Practical consequence:

- examples are the best source for intended day-to-day usage
- definitions are the best source for lower-level contracts and caveats
- answers should usually mention when an example is using a std wrapper over a lower-level runtime primitive

## Filesystem Recipes

### Write a File

Low-level handle-based write:

```luau
local fs = require("@std/fs")

local file = fs.open("dest", "w+")
fs.write(file, "This is some other text")
fs.close(file)
```

Practical takeaway:

- examples still show explicit open/write/close when teaching the primitive shape
- `"w+"` truncates or creates the file, so this is not a safe append pattern

### Create and Remove a Directory

```luau
local fs = require("@std/fs")
local path = require("@std/path")
local system = require("@std/system")

local tmpdir = system.tmpdir()
local directory = path.join(tmpdir, "example_dir")

fs.createDirectory(directory, { makeParents = true })
fs.removeDirectory(directory)
```

Practical takeaway:

- the std wrapper provides `makeParents = true`
- directory operations are usually combined with `@std/path` and `@std/system`

### List a Directory

```luau
for _, file in fs.listDirectory("./examples") do
    print(`Example {file.name} is a {file.type}`)
end
```

Practical takeaway:

- list operations yield `{ name, type }` entries
- examples treat directory listing as immediate child enumeration, not recursive walking

### Read Metadata

```luau
local metadata = fs.metadata(scriptPath)
local created = metadata.created
print(tostring(created))
```

Practical takeaway:

- metadata timestamps are usable as structured time values, not just raw integers

### Walk a Directory Tree

```luau
local it = fslib.walk(baseDir, { recursive = true })
local walker = it()
while walker do
    print("Found:", walker)
    walker = it()
end
```

Practical takeaway:

- `walk` returns an iterator function
- recursive traversal must be requested explicitly

### Watch for Changes

```luau
local watcher = fs.watch(tmpdir)

repeat
    event = watcher:next()
    if not event then
        task.wait(0.01)
    end
until event or (os.clock() - start > 2)
```

Practical takeaways:

- the std watcher is polled with `:next()`
- examples add a timeout loop instead of blocking forever
- `task.wait` is used to avoid a busy spin

What to avoid:

- do not present file watching as a blocking `for` loop over events

## Process and Environment Recipes

### Run a Program Directly

```luau
local result = process.run({ "echo", "Hello, lute!" })
print(result.exitcode)
print(result.stdout)
```

Use this pattern when argument boundaries matter.

### Run Through a Shell

```luau
local r4 = process.system("echo Hello, lute!")
print(r4.stdout)
```

Use this when shell expansion or shell builtins matter.

### Override Environment Variables

```luau
local r5 = process.system("echo $HOME", { env = { HOME = "/home/lute" } })
```

Practical takeaway:

- the example treats `env` as an override table for child execution

### Change Child Working Directory

```luau
local r6 = process.run({ "pwd" }, { cwd = "/" })
```

### Inspect and Mutate Current Process Environment

```luau
print(process.env.HOME)
process.env.LUTE_HOME = "/home/lute"
print(process.env.LUTE_HOME)
```

Practical takeaway:

- `process.env` is not just readable; examples mutate it directly

### Choose A Shell Explicitly

```luau
local r8 = process.system("echo $0", { system = "/bin/sh" })
```

What to avoid:

- do not assume the default shell if shell behavior is important to correctness

## System Recipes

### Machine Summary

The system example combines:

- `hostName()`
- `os`
- `arch`
- `threadCount()`
- `uptime()`
- `freeMemory()`
- `totalMemory()`

into one diagnostic print.

Practical takeaway:

- the intended use is operational introspection, not just isolated getters

### CPU Enumeration

The example iterates `system.cpus()` and hints that each entry exposes model, speed, and per-category timing breakdowns.

## Task and Time Recipes

### Wait Using Seconds Or `Duration`

```luau
print(task.wait(1))
print(task.wait(time.duration.seconds(1)))
print(task.wait())
```

Practical takeaway:

- `task.wait` accepts both plain numbers and `Duration`
- no-argument `wait()` is also valid

### Delay A Function Or Coroutine

```luau
task.delay(1, coroutine.create(print), vector.one)
task.delay(1, print, vector.one)
```

Practical takeaway:

- examples explicitly show both forms

### Resume Coroutines Manually

```luau
task.resume(c)
task.resume(c, "world", "meow for good measure")
task.spawn(print, 3, 2, 1)
```

Practical takeaway:

- argument forwarding is part of the intended design
- `resume` is used as a scheduler-facing primitive, not just raw coroutine API nostalgia

## Networking Recipes

### HTTP Requests

```luau
print(net.request("https://en.wikipedia.org/").status)
print(net.request("https://httpbin.org/post", {
    method = "POST",
    headers = {
        ["Content-Type"] = "application/json",
    },
    body = '{"name":"lute"}',
}).body)
```

Practical takeaway:

- request metadata is optional
- `POST` workflows are modeled through `method`, `headers`, and `body`

### Concurrent Requests

The example launches several requests with `task.spawn` and waits until a shared counter reaches completion.

Practical takeaway:

- examples model concurrency cooperatively rather than with a promise abstraction

### Serve HTTP

```luau
local server = require("@lute/net/server")

local instance = server.serve(function(_)
    return "Hello, lute!"
end)
```

Practical takeaway:

- a plain string is a valid server response
- serving is non-blocking in this example

What to avoid:

- do not assume the server call blocks the whole process unless confirmed elsewhere

## Testing Recipes

The main testing example lives elsewhere in the corpus, but `examples/testing.luau` adds useful nuance:

- lifecycle hooks are shown in one place
- failing assertions are intentionally included to demonstrate reporting
- table equality and thrown-error assertions are exercised specifically to show debugging behavior

Practical takeaway:

- some examples are meant to demonstrate failure output, not only success patterns

## Documentation and Type-Introspection Recipes

### Source Comment Extraction

`examples/docs/test_module.luau` and its generated markdown show which comments are intended to become docs.

Practical takeaways:

- `---` comments directly above declarations are treated as doc text
- multiple triple-dash lines are preserved
- property/type declarations can also be documented
- ordinary `--` comments are not equivalent API docs

### Module Return-Type Introspection

`examples/module_return_type/get_module_return_type.luau` uses `@std/luau.typeofModule(...)` to inspect the exported type of a module.

Practical takeaway:

- this is useful for tooling, code intelligence, and type-aware transforms
- the example defensively checks for missing `returnType`, missing `head`, and non-table cases before reading properties

What to avoid:

- do not assume module return-type introspection always yields a simple table result

## Cookbook Navigation

When using examples to answer future questions:

- for filesystem workflows, start here and then validate edge cases against `runtime-definitions-and-caveats.md`
- for tests, combine this file with the dedicated tutorial material
- for process/system questions, keep shell-vs-argv behavior explicit
- for task/time questions, keep cooperative scheduling semantics explicit
