# Language Syntax

## Commands

Commands start on a new line with an identifier or variable-like target:

```text
command1
$command1
$table.value
```

Bare identifiers used as arguments are coerced into strings:

```text
print value1 value2 value3
```

## Variables

Assignment uses `=`. If the next token is an identifier, Conch treats it as a command invocation; otherwise it parses an expression.

```text
variable = command1
variable = "Hello World!"
```

## Literals

### Strings

```text
print "Hello World!"
variable = "Hello World!"
```

Use quoted strings when the text would not parse as a normal identifier.

### Numbers

Supported forms include:

- Decimal
- Underscore separators
- Scientific notation
- Hexadecimal via `0x`
- Binary via `0b`

Examples:

```text
give-money 100_000
give-money 1e6
set-flags 0b1111_1111
set-hexadecimal-value 0xFFFFFF
```

### Tables

Tables mimic Luau-style table literals:

```text
array = { 1, 2, 3, 4 }
dictionary = { value = 1234, ["test"] = 1234, [meow] = true }
mixed = { value = 1234, 1, 2, 3, 4 }
```

Identifiers inside table literals are coerced into strings unless explicitly indexed another way.

### Vectors

Vectors use square brackets with three values:

```text
vector = [1, 2, 3]
```

## Nested Commands

Commands cannot execute directly while constructing table or vector literals. Wrap nested command execution with `$()`:

```text
value = { [$( command1 "meow" )] = true }
```

## Booleans

`true` and `false` are keywords:

```text
value = true
```

## Function Literals

Functions use `|args| { ... }` or `|| { ... }`:

```text
meow = || {
	print "meow!"
}

foo = |argument| {
	print $argument
}
```

They can later be evaluated manually:

```text
$meow
$foo
```

## Control Flow

Conch supports basic control flow:

- `if`
- `else if`
- `else`
- `while`
- `for`
- `break`
- `continue`

Examples:

```text
if (false) {

} else {

}
```

```text
while (true) {
	break
}
```

```text
for ($table) | key, value | {
	print $key $value
}
```

## Caveat

The docs describe control-flow support as experimental. Treat these constructs as available, but avoid assuming the same maturity as the simpler command and argument flow.
