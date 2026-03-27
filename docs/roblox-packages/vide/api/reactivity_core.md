Reactivity: Core
Scopes
Vide code can run in one of two scopes: STABLE or REACTIVE.

Reactive scopes rerun if a source read within updates.
Stable scopes never rerun.
Reactive scopes cannot be created directly within another reactive scope.
When a scope is destroyed, all scopes created within are also destroyed.
Different functions in Vide's API will run code in different scopes.

WARNING

Yielding is not allowed in any stable or reactive scope. Strict mode will check for this.

root() STABLE
Runs a function in a new stable scope.

Type

function root<T...>(fn: (Destructor) -> T...): (Destructor, T...)

type Destructor = () -> ()
Details

Returns a destructor and any values returned by the callback.

source()
Creates a new source.

Type

function source<T>(value: T): Source<T>

type Source<T> =
() -> T -- get
& (T) -> () -- set
Details

Call the returned source with no argument to read its value. Call the returned source with an argument to set its value.

Example

local count = source(0)
print(count())-- 0
count(count() + 1)
print(count()) -- 1
effect() REACTIVE
Runs a function in a new reactive scope.

Type

function effect(fn: () -> ())
Details

The function is ran once immediately.

Example

local count = source(1)

effect(function()
print(count())
end)

-- prints 1

count(2)

-- prints 2
derive() REACTIVE
Runs a function in a new reactive scope to compute a value for new source.

Type

function derive<T>(fn: () -> T): () -> T
Details

Anytime the reactive scope reruns, the output source value is set to what is returned.

The function is ran once immediately.

Example

local count = source(0)
local text = derive(function() return `count: {count()}` end)

print(text()) -- "count: 0"

count(1)

print(text()) -- "count: 1"
A derive() should be used instead of a pure function when you expect it to be read multiple times between updates, because derive() will cache the result to prevent recomputing it on every read.

Pure Function

Derived Source

local count = source(0)

local text = function()
print "ran"
return `count: {count()}`
end

count(1)
print(text()) -- prints "ran" followed by "count: 1"
print(text()) -- prints "ran" followed by "count: 1"
