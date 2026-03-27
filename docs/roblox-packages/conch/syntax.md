Syntax
Commands
Commands start on a new line with an identifier or variable (index). This will be called.

command1
$command1
$table.value
Providing identifiers to a command will call the command with the given arguments. Identifiers automatically get coerced into strings.

print value1 value2 value3
Variables
A variable is the result of a command or expression. You can define variables by suffixing an identifier with the = sign. When the next token after the = sign is an identifier, it's considered a command and will be called. Otherwise, it's considered an expression.

variable = command1
String Literals
You can create string literals by surrounding a string with "". You can pass string literals to commands and variables. Using a string literal lets you pass strings that cannot be parsed as an identifier

print "Hello World!"
variable = "Hello World!"
Number Literals
Numbers consist of a sequence of digits and optionally a period inbetween. You are allowed to use underscores and e in your numbers.

give-money 100_000
give-money 1e6
n = 1e6
You can write hexadecimal or binary numbers by prefixing it with 0x or 0b.

set-flags 0b1111_1111
set-hexadecimal-value 0xFFFFFF
Table Literals
You can define tables similar to luau inside Conch. They respect all luau semantics. Identifiers are automatically coerced into strings.

array = { 1, 2, 3, 4 }
dictionary = { value = 1234, ["test"] = 1234, [meow] = true }
mixed = { value = 1234, 1, 2, 3, 4 }
Vector Literals
Vectors can be defined by surrounding 3 values with [].

vector = [1, 2, 3]
Nested Commands
Conch doesn't allow executing commands when defining tables or vector literals. You can get around this by wrapping your command with $().

value = { [$( command1 "meow" )] = true }
Booleans
true and false are keywords, and when used convert to a boolean.

value = true
Function Literals
Functions can be defined by surrounding a list of arguments with || and then providing a body with {}.

meow = || {
print "meow!"
}

foo = |argument| {
print $argument
}
You can then evaluate these functions manually in your code.

$meow
$foo
Control Flow
Conch provides basic control flow statements to allow for writing more complex commands. By default, conch comes with if, while and for. Conch also provides break and continue statements. These are currently experimental features.

if (false) {

} else {

}

if (command1 true) {

} else if (command2 true) {

}

while (true) {
break
}

for ($table) | key, value | {
print $key $value
}

for (command1) |key, value| {
print $key $value
}
