# AST API

## Main Entry Points

The AST layer is exposed through the language package and directly through the AST package namespace.

## Parser API

### `parse(buffer): Output`

Parse Conch source into an AST.

Output shape:

```ts
{
	issues: Issue[],
	result?: Ast
}
```

Important caveat:

- Parsing is commonly wrapped in `pcall`, because issue-bearing parses may throw the structured output instead of always returning it normally.

### `Issue`

```ts
{
	why: string,
	span: vector
}
```

## Visitor API

### `create_visitor<State>(): Visitor<State>`

Create a no-op visitor object with every visit hook populated.

### `visit_ast(visitor, state, node): void`

Traverse a whole AST.

### `visit_block(visitor, state, node): void`

Traverse a block specifically.

### `Visitor<State>`

The visitor surface is extensive and covers:

- blocks
- tokens
- function arguments
- commands
- statements
- `for`, `while`, `if`, assignments, command statements
- branches
- `return`, `break`, `continue`
- tables and table fields
- vars and var suffixes
- expression variants

Every major node type has both enter and end hooks.

## Display API

The display module pretty-prints AST nodes back into source-like text.

Exposed functions include:

- `display_assign`
- `display_block`
- `display_break`
- `display_command`
- `display_continue`
- `display_delimited`
- `display_else_branch`
- `display_elseif_branch`
- `display_expression`
- `display_for`
- `display_function_body`
- `display_if`
- `display_if_branch`
- `display_last_statement`
- `display_return`
- `display_separated`
- `display_statement`
- `display_table`
- `display_tablefield`
- `display_token`
- `display_var`
- `display_var_root`
- `display_var_suffix`
- `display_while`

These are useful for:

- debugging parses
- rebuilding readable source
- AST tooling and transforms

## AST Node Families

The package exposes type aliases for:

- tokens and token kinds
- binary and unary operators
- delimited and separated sequences
- expressions
- commands
- vars and var suffixes
- table fields
- statements
- control-flow branches
- blocks
- whole ASTs

The AST package is therefore both a parser entry point and the structural schema used by analysis and execution.
