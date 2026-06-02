# Overview, Getting Started, and Tutorials

## What Lute Is

Lute is a standalone runtime for general-purpose programming in Luau. It fills the gap left by Luau's usual embedded/sandboxed environments by exposing capabilities such as:

- file-system access
- HTTP and networking
- sockets
- process management
- cryptography
- code analysis and source transformation

The intended mental model is "Node.js or Deno, but for Luau."

## Library Model

Lute is presented primarily in terms of two related layers:

| Layer  | Purpose                                                                         |
| ------ | ------------------------------------------------------------------------------- |
| `lute` | Core runtime libraries implemented in C++ for general-purpose Luau programming. |
| `std`  | Higher-level Luau standard library built on top of runtime capabilities.        |

The docs explicitly encourage contributions across the runtime and standard-library layers.

## Installation

### Stable Releases

Stable releases follow semantic versioning and are published on the GitHub releases page.

### Install With Rokit

Use a project-local toolchain install:

```bash
rokit add luau-lang/lute@1.0.0
```

### Install With Foreman

Create a `foreman.toml`:

```toml
[tools]
lute = { github = "luau-lang/lute", version = "1.0.0" }
```

Then install:

```bash
foreman install
```

### Docker Availability

Official images are published on stable releases. A minimal example:

```bash
docker run --rm -it -v "$PWD:/app" -w /app ghcr.io/luau-lang/lute run script.luau
```

The dedicated Docker reference contains image variants and tag strategy.

### Nightly Builds

Nightlies are installable through the same manager flows by targeting a nightly version string such as:

```text
0.1.0-nightly.2024-06-01
```

## First Project Setup

The introductory docs recommend:

1. Create a project folder.
2. Create a `main.luau`.
3. Run `lute setup` before serious editing so language-server definitions are available.

`lute setup` writes definition files under `.lute/` in the user's home directory so `luau-lsp` can provide autocomplete and type checking.

## Hello World

Minimal file:

```luau
print("Hello World")
```

Run it with either:

```bash
lute run main.luau
```

or the shorthand:

```bash
lute main.luau
```

The docs note that the shorthand works for any Luau script path, not only `main.luau`.

## Tutorial: Writing a Guessing Game

The guessing-game tutorial is useful because it encodes several core Lute concepts, not just beginner syntax.

### Using `@std`

The tutorial introduces user input through:

```luau
local io = require("@std/io")
```

Key concepts preserved from the docs:

- `@std` and `@lute` are reserved aliases provided by Lute.
- `require` still works for local modules you author yourself.
- `io.input()` waits for terminal input and returns a string.

Example:

```luau
local io = require("@std/io")

print("Say something! ")
local input: string = io.input()
print(input)
```

### Luau Builtins vs Lute Capabilities

The tutorial explicitly distinguishes:

- Luau builtins such as `math.random`
- Lute-provided capabilities for interacting with the outside world

That distinction matters in later answers because not everything visible in Lute comes from the runtime itself.

### Input Conversion

The docs call out that `input()` returns a string, so numeric comparison requires `tonumber`.

```luau
local guess: number? = tonumber(input)
```

Important note preserved from the docs:

- without checking for `nil`, invalid numeric input will break the logic
- `continue` is used to skip the rest of the loop and re-prompt the user

Example validation pattern:

```luau
local guessedRight = false
while not guessedRight do
    print("Guess a number: ")
    local input = io.input()
    local guess: number? = tonumber(input)

    if not guess then
        print(`Not a number: {input}`)
        continue
    end

    if guess > randomNumber then
        print("Too high!")
    elseif guess < randomNumber then
        print("Too low!")
    else
        print("Got it!")
        guessedRight = true
    end
end
```

### Command-Line Arguments

The tutorial explains that scripts receive arguments through `...`:

```luau
local args = { ... }
```

Important command-line convention preserved from the docs:

- `args[1]` is the script name
- remaining arguments follow after it

The tutorial's example parses `--max <number>` and defaults to `100`. Final version:

```luau
local io = require("@std/io")
local args = { ... }

local function getArgs(args): number
    if #args == 2 then
        error("Didn't pass enough arguments")
    elseif #args < 2 then
        return 100
    else
        if args[2] == "--max" then
            local argument = tonumber(args[3])
            if argument then
                return argument
            end
        end
    end
    return 100
end

local maxValue = getArgs(args)
local randomNumber = math.random(maxValue)
```

Example invocation:

```bash
lute main.luau --max 50
```

### Author Note Preserved

The tutorial ends with a TODO worth keeping because it captures future workflow intent:

- potentially add a `lute new <proj>` command that creates `main.luau`, sets up a `luaurc`, and creates a `tests` directory

## Tutorial: Writing Tests

This guide uses the guessing-game argument parser as the teaching example.

### Suggested Project Shape

```text
project/
    utils.luau
    args.test.luau
```

### Example Module Under Test

The docs export a frozen table:

```luau
local function getArgs(args): number
    if #args == 2 then
        error("Didn't pass enough arguments")
    elseif #args < 2 then
        return 100
    else
        if args[2] == "--max" then
            local argument = tonumber(args[3])
            if argument then
                return argument
            end
        end
    end
    return 100
end

return table.freeze({ getArgs = getArgs })
```

The freezing detail is useful context: the docs intentionally model the module as immutable/read-only.

### Basic Test Case With `@std/test`

```luau
local test = require("@std/test")
local utils = require("./utils")

test.case("maxOverridesValue", function(asserts)
    local fakeArgs = { "fakeScript.luau", "--max", "20" }
    local result = utils.getArgs(fakeArgs)

    asserts.eq(20, result)
end)
```

### Argument-Passing Convention

The docs explicitly preserve the convention:

- shells invoke `lute` with the program path plus remaining arguments
- Lute then passes the script path as the first argument to the script

That is why test fixtures include `"fakeScript.luau"` as the first element.

### Running Tests

Minimal run:

```bash
lute test
```

Example success output:

```text
──────────────────────────────────────────────────
Results: 1 passed, 0 failed of 1
```

### Additional Test Cases

The tutorial adds:

- default-value behavior when no `--max` is passed
- error behavior when `--max` is missing its numeric argument

Example error assertion:

```luau
test.case("noArgToMax", function(asserts)
    local fakeArgs = { "fakeScript.luau", "--max" }
    asserts.errors(function()
        utils.getArgs(fakeArgs)
    end)
end)
```

### Organizing With Suites

The guide recommends `test.suite` for grouping tests and for lifecycle hooks such as:

- `beforeEach`
- `beforeAll`
- `afterEach`
- `afterAll`

Example suite:

```luau
local test = require("@std/test")
local utils = require("./utils")

test.suite("GetArgsTest", function(suite)
    suite:case("maxOverridesValue", function(asserts)
        local fakeArgs = { "fakeScript.luau", "--max", "20" }
        local result = utils.getArgs(fakeArgs)
        asserts.eq(20, result)
    end)

    suite:case("noPassingMax", function(asserts)
        local fakeArgs = { "fakeScript.luau" }
        local result = utils.getArgs(fakeArgs)
        asserts.eq(100, result)
    end)

    suite:case("noArgToMax", function(asserts)
        local fakeArgs = { "fakeScript.luau", "--max" }
        asserts.errors(function()
            utils.getArgs(fakeArgs)
        end)
    end)
end)
```

### Re-Running Narrow Test Scopes

The docs explicitly call out these targeted commands:

```bash
lute test -c caseName
lute test -s suiteName
lute test tests/path/to/.test.luau
```

### File-System Test Hygiene

The guide includes a practical note about temp-directory cleanup between tests. The recommended pattern uses `beforeEach` with `@std/fs`, `@std/path`, and `@std/system`:

```luau
local test = require("@std/test")
local fs = require("@std/fs")
local path = require("@std/path")
local system = require("@std/system")

local testDir = path.join(system.tmpdir(), "test")

test.suite("FileCreation", function()
    test.beforeEach(function()
        fs.removedirectory(testDir, { recursive = true })
        fs.createdirectory(testDir)
    end)
end)
```

This is more than a tutorial detail; it is useful troubleshooting guidance for stateful tests.

### Debugging a Failing Test

The guide demonstrates a failing test for an unsupported argument:

```luau
suite:case("unsupportedArgument", function(asserts)
    local fakeArgs = { "fakeScript.luau", "--what", "foo" }
    asserts.errors(function()
        utils.getArgs(fakeArgs)
    end)
end)
```

Observed failure output:

```text
Failures:

  FAIL getArgsTest.unsupportedArgument
        .../args.test.luau:26
        errors: function: 0x000000012f859740 did not throw error.
```

The docs use that failure to motivate the fix:

```luau
local function getArgs(args): number
    if #args == 2 then
        error("Didn't pass enough arguments")
    elseif #args < 2 then
        return 100
    else
        if args[2] == "--max" then
            local argument = tonumber(args[3])
            if argument then
                return argument
            end
        else
            error(`Expected flag --max, but got {args[2]}`)
        end
    end
    return 100
end
```

## Developer Tooling Summary

The docs explicitly highlight two day-to-day tools:

- `lute test` for discovering and running `.spec.luau` and `.test.luau` files, typically under `tests/`
- `lute lint` for programmable linting in Luau, including custom rules plus built-in defaults
