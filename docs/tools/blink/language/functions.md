# Functions

Functions are Blink's version of Roblox's RemoteFunction.
They provide a way for the client to request information from the server.

Usage in Blink
Functions can be defined using the function keyword.

```
function MyFunction {
```

Yield: Coroutine,
Data: f64,
Return: f64
}

Yield
Determines the library used to handle yielding to the requester.

Coroutine - The builtin Luau coroutine library.
Future - The user provided future library, use of redblox's future library is recommended.
Promise - The user provided promise library, use of evaera's promise library (or forks of it) is recommended.
Data
The data sent to the server by the client.
For more information take a look at the data field for events.

Return
The data returned by the server to the client.
For more information take a look at the data field for events.

Usage in Luau
Invoking a Function
client-coroutine.luau
```
local Value = blink.MyFunction.Invoke(5)

```
client-future.luau
```
local Future = blink.MyFunction.Invoke(5)
local Value = Future:Await()

```
client-promise.luau
```
local Promise = blink.MyFunction.Invoke(5)
local Value = Promise:await()

```
Listening to a Function
```
server.luau
blink.MyFunction.On(function(Player, Value)
```

return Value \* 2
end)
