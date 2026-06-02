# Linting and Built-In Rules

## Overview

`lute lint` is a programmable Luau linter that ships with Lute.

Important positioning preserved from the docs:

- it is built for static analysis of common pitfalls and discouraged patterns
- it is programmable in Luau itself
- it is built on the official Luau language stack, using the same parser family as Luau and Roblox
- the repository includes sample custom lint rules

## Command Usage

```bash
lute lint [OPTIONS] [...PATHS]
```

Only `.luau` and `.lua` files are linted.

## Options

- `-h, --help`: show help
- `-v, --verbose`: enable verbose output
- `-r, --rules [RULE]`: load a single rule file or a folder of rules
- `-c, --config [CONFIG]`: load lint config from a file
- `-j, --json`: emit JSON output matching the LSP diagnostic shape
- `-s, --string-input`: lint a provided string instead of files
- `--sequential`: lint files sequentially instead of in parallel
- `--auto-fix`: apply suggested fixes automatically when they do not overlap
- `--no-default-lints`: disable the built-in default rules

## Rule Loading Behavior

When `-r` points to a folder:

- subfolders containing `init.luau` are treated as modules exporting lint rules
- other `.luau` files are treated as individual lint rules

If `-r` is omitted, Lute uses the default built-in rules.

## Config File Shape

If `-c` is omitted, Lute looks for `.config.luau` in the current working directory.

Documented structure:

```luau
type RuleName = string

type Config = {
    lute: {
        lint: {
            ignores: { string }?,
            globals: { [string]: unknown }?,
            rulepaths: { [string] }?,
            ruleconfigs: {
                [RuleName]: {
                    ignores: { string }?,
                    severity: ("warn" | "error" | "info" | "hint")?,
                    options: { [string]: unknown }?,
                    off: boolean?,
                },
            }?,
        }?,
    }?,
}
```

Key meanings preserved from the docs:

- `ignores`: `.gitignore`-style glob patterns excluded from linting
- `globals`: string-to-unknown values passed down to each rule
- `rulepaths`: local paths from which rules are loaded
- `ruleconfigs`: per-rule ignores, severity overrides, options, and disable switches

## Examples

Lint with a single custom rule:

```bash
lute lint -r examples/lints/almost_swapped.luau bad_swap.luau
```

Lint with a folder of custom rules:

```bash
lute lint -r examples/lints/ lintee.luau src_code/
```

## Built-In Rules

The docs currently describe the following default rules.

### `almost_swapped`

Detects attempted swaps such as:

```luau
a = b
b = a
```

Why it is discouraged:

- it does not actually swap values
- after the first assignment, both names end up referencing the original value of `b`

Preferred fix:

```luau
a, b = b, a
```

### `constant_table_comparison`

Detects comparisons against table literals such as:

```luau
if x == {} then
    ...
elseif x ~= {} then
    ...
end
```

Why it is discouraged:

- Luau compares tables by reference, not by value
- a table literal creates a fresh table each time
- comparing an existing table to a fresh literal will not do what users typically expect

Preferred pattern for emptiness checks:

```luau
if next(x) == nil then
    ...
elseif next(x) ~= nil then
    ...
end
```

### `divide_by_zero`

Detects division, floor division, or remainder operations against the literal `0`:

```luau
local x = 3 / 0
local y = -4 // 0
local z = 24 % 0
```

Why it is discouraged:

- division/floor-division by zero generally yields `inf` or `-inf` unless the dividend is `0`
- remainder by zero yields `NaN`

Preferred explicit forms:

```luau
local x = math.huge
local y = -math.huge
local z = math.nan
```

### `duplicate_keys`

Detects duplicate keys in table literals, including collisions between map-like and array-like entries.

Example violation:

```luau
local t = {
    key = 1,
    ["key"] = 2,
    "array-like-value1",
    "array-like-value2",
    [2] = "map-like-value",
}
```

Why it is discouraged:

- it is usually accidental
- only one of the conflicting values survives in the final table

### `empty_if_block`

Detects empty `if`, `elseif`, and `else` blocks.

Why it is discouraged:

- often indicates incomplete or low-signal code
- hurts readability

Example violations:

```luau
if condition then
end

if condition then
    -- Empty then block
elseif otherCondition then
    doSomething()
end

if condition then
    doSomething()
else
    -- Empty else block
end
```

#### Rule Option

`comments_count`:

- type: `boolean`
- default: `false`
- meaning: when `true`, comment-only blocks are treated as non-empty

Example:

```luau
if condition then
    -- TODO: implement this later
end
```

Sample config:

```luau
return {
    lute = {
        lint = {
            rules = {
                empty_if_block = {
                    options = {
                        comments_count = true,
                    },
                },
            },
        },
    },
}
```

### `global_function_in_scope`

Warns when a non-local `function` declaration appears inside a nested scope.

Example violation:

```luau
if true then
    function foo()
    end
end

local function outer()
    function inner()
    end
end
```

Why it is discouraged:

- it implicitly writes to a global
- the write only occurs when the enclosing scope executes
- it can leak names and create shadowing/debugging problems

Preferred fix:

```luau
if true then
    local function foo()
    end
end

local function outer()
    local function inner()
    end
end
```

### `no_any`

Detects explicit `any` type annotations.

Why it is discouraged:

- `any` disables type checking for the values it touches
- bugs are hidden instead of surfaced

Preferred guidance preserved from the docs:

- use `unknown` instead
- narrow the type with checks such as `typeof`
- if necessary, use an explicit unsound cast `value :: T` to make the assumption visible

Example violation:

```luau
local x: any = getValue()
local function process(input: any): any
    return input.field
end
type Callback = (any) -> any
```

Safer alternative:

```luau
local x: unknown = getValue()
local function process(input: unknown): unknown
    assert(typeof(input) == "table")
    return (input :: { field: unknown }).field
end
type Callback = (unknown) -> unknown
```

### `parenthesized_conditions`

Detects conditions written with unnecessary parentheses.

Example violation:

```luau
if (x > 5) then
    ...
end
```

Why it is discouraged:

- no semantic benefit
- unidiomatic
- can reduce readability

Preferred form:

```luau
if x > 5 then
    ...
end
```

### `unused_variable`

Detects unused locals, including function parameters and loop variables.

Important distinction preserved from the docs:

- this goes beyond Luau's built-in linter by also flagging unused parameters and loop variables

Silencing rule:

- deliberately unused values can be prefixed with `_`

Example violation:

```luau
local function _(x)
    return nil
end
```

Preferred alternatives:

```luau
local function _()
    return nil
end
```

or:

```luau
local function _(_x)
    return nil
end
```
