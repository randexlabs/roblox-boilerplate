# Code Transforms and Program Analysis

## Why This Matters

One of Lute's strongest differentiators is that it exposes parts of the Luau language stack for programmatic tooling work, including:

- types
- require resolution
- the Luau concrete syntax tree (CST)
- Luau bytecode

This powers `lute transform`, which is designed for automated and deterministic source transformations.

## Transform Mental Model

A transform is a Luau module that returns a function. That function receives a context and returns a replacement map from original CST nodes to replacement strings.

Documented context shape:

```luau
export type Context<Options = { [any]: any }> = {
    path: string,
    source: string,
    parseresult: syntax.ParseResult,
    options: Options,
}
```

Important design note preserved from the docs:

- CSTs are treated as immutable
- transforms describe replacements rather than mutating nodes in place

## Replacement Map Contract

The expected result type is:

```luau
{ [CstNode]: string }
```

The docs explicitly note:

- only string replacements are currently supported directly
- manually constructing CST nodes is possible but more error-prone
- if you build CST fragments manually, use `@std/printer` to serialize them before inserting them into the replacement map

## Query-Based CST Transforms

The docs present the query-based style as the default choice for most transforms.

### Example Goal

Double every numeric literal in a source program.

### Selecting Nodes

The primary example begins with:

```luau
query.findAllFromRoot(cstRoot, utils.isExprConstantNumber)
```

The predicate returns either a matching node or `nil`. Example helper:

```luau
function utils.isExprConstantNumber(n: types.CstNode): types.CstExprConstantNumber?
    return if n.kind == "expr" and n.tag == "number" then n else nil
end
```

Important structural details preserved from the docs:

- every `CstNode` has a `kind`
- every `CstNode` has a `tag`
- `kind` identifies a broad category
- `tag` identifies the exact node type

### Producing Replacements

```luau
local replacements = query.findAllFromRoot(cstRoot, utils.isExprConstantNumber)
    :replace(function(numLiteral: CstExprConstantNumber)
        return `{ numLiteral.value * 2 }`
    end)
```

The docs emphasize that `:replace` handles the collection of transformed results into the final map.

### Full Query-Based Transform

```luau
local cst = require("@std/syntax")
local query = require("@std/syntax/query")
local utils = require("@std/syntax/utils")

local function transformQuery(ctx)
    return query.findAllFromRoot(ctx.parseresult, utils.isExprConstantNumber)
        :replace(function(numLiteral: cst.CstExprConstantNumber)
            return `{ numLiteral.value * 2 }`
        end)
end

return transformQuery
```

### Example Invocation

If `transform.luau` contains the transform above and `subject.luau` contains:

```luau
local x = 2
```

then:

```bash
lute transform transform.luau subject.luau
```

should rewrite it to:

```luau
local x = 4
```

## Visitor-Based CST Transforms

The docs also present a visitor-pattern approach for transforms that need more explicit traversal control.

### Starting Point

```luau
local myVisitor = visitor.create()
local replacements: { [cst.CstNode]: string } = {}
```

### Overriding Node Handlers

You customize behavior by defining methods for specific node types:

```luau
function myVisitor.visitExprConstantNumber(numberLiteral: cst.CstExprConstantNumber)
    -- do something
    return false
end
```

Critical behavioral detail preserved from the docs:

- the return value controls whether traversal recurses into subnodes
- returning `false` stops recursion into that node's children

The docs use `if` statements as an example:

```luau
local anotherVisitor = visitor.create()

function anotherVisitor.visitStatIf(ifStatement: cst.CstStatIf)
    return false
end
```

This would skip the condition and branch bodies of visited `if` statements.

### Visitor Example for Number Literals

```luau
local myVisitor = visitor.create()
local replacements: { [cst.CstNode]: string } = {}

function myVisitor.visitExprConstantNumber(numberLiteral: cst.CstExprConstantNumber)
    replacements[numberLiteral] = `{ numberLiteral.value * 2 }`
    return false
end
```

The docs call out that number literals have a token subnode, but that recursion into it is unnecessary for this transform.

### Running the Visitor

```luau
visitorLib.visit(cst, myVisitor)
```

### Full Visitor-Based Transform

```luau
local cst = require("@std/syntax")
local visitorLib = require("@std/syntax/visitor")

local function visitorTransformation(ctx)
    local myVisitor = visitorLib.create()
    local replacements: { [cst.CstNode]: string } = {}

    function myVisitor.visitExprConstantNumber(numberLiteral: cst.CstExprConstantNumber)
        replacements[numberLiteral] = `{ numberLiteral.value * 2 }`
        return false
    end

    visitorLib.visit(ctx.parseresult.root, myVisitor)

    return replacements
end

return visitorTransformation
```

## Choosing Between Query and Visitor Approaches

The source docs do not present this as a strict rule, but the practical guidance is clear:

- prefer the query-based approach for most transformations
- reach for the visitor pattern when traversal control or custom visitation behavior matters more

## Command-Side Behavior

When using these transforms through the CLI:

- `lute transform <transformer> <files...>` applies the transform
- `--dry-run` computes changes without rewriting files
- `--output <path>` is valid only when transforming a single file
- custom transformer options can be passed on the CLI and parsed into transform options
