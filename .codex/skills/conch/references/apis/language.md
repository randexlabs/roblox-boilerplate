# Language VM API

## Main Surface

`conch_language` is the low-level language package that exposes parsing, execution, analysis, and display helpers.

## Exported Functions

### `create_vm(): LanguageVm`

Create a fresh language VM with:

- `global_metadata`
- `vars_metadata`
- `state`

### `set_command(vm, key: string, value: unknown): void`

Register or replace a global command-like value in the VM.

### `set_variable(vm, key: string, value: unknown): void`

Register or replace a scoped variable in the VM’s root scope.

### `attach_info(vm, isVar: boolean, key: string, value: Type): TypeAnalysisInfo`

Attach analysis metadata to a global or variable entry.

Returned handle:

```luau
{ remove: () -> () }
```

### `run(vm, input: string): RunResult`

Parse and execute Conch source.

Result:

- `{ ok = true, values = { unknown }? }`
- `{ ok = false, why = { string } }`

Behavior:

- Parse errors become formatted issue strings with spans.
- Execution errors return a stringified error payload.

### `analyze(vm, input: string, cursor: number): AnalysisResult?`

Analyze input for suggestions, replacement span, issues, and additional info.

### `matches_type(value, type, exact?): boolean`

Low-level compatibility check used by the runtime to resolve overloads and coercion.

### `display`

Namespace of AST pretty-print helpers re-exported from the AST package.

## Exported Type Families

The package re-exports:

- `LanguageVm`
- `TypeAnalysisInfo`
- `SimpleValue`
- `Suggestion`
- `Metadata`
- `Type`
- `LiteralType`
- `StrangeType`
- `UnionType`
- `IntersectionType`
- `TableType`
- `FunctionType`
- `CommandType`
- `CommandArgument`
- `AnalysisResult`
- `InputState`

## Execution Model Notes

- The language VM stores globals and variables separately.
- Execution state is rooted in a treewalker state object.
- Parse failures are not silent; they are normalized into `why` messages by `run()`.
- The same AST and analysis types drive both user-facing command registration and lower-level tooling.
