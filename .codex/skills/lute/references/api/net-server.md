# `definitions/net/server.luau`

## Purpose

This definition file describes the low-level server-side networking API exposed under `@lute/net/server`.

Use this file when the question is about:

- HTTP server startup
- request handler contracts
- server response shapes
- server-side WebSockets

## Request and Response Types

### `ReceivedRequest`

Fields:

- `method`
- `path`
- `body`
- `query`
- `headers`

Practical meaning:

- handlers receive a structured request object, not just a raw path and body

### `ServerResponse`

This is a union:

- a plain `string`
- or a table with optional `status`, `body`, and `headers`

Practical consequence:

- trivial handlers can return a string directly
- richer handlers can build a response object

What to avoid:

- do not claim every handler must build a response table

## Server WebSocket Types

### `ServerWebSocket`

Methods:

- `:send(data: string | buffer) -> number`
- `:close(code?, message?)`

Important caveat:

- payloads can be `string` or `buffer`

### `WebSocketHandlers`

Optional callbacks:

- `open`
- `message`
- `close`
- `drain`

Practical meaning:

- backpressure or send-drain handling is part of the server-side contract

## Server Type

### `Server`

Fields/methods:

- `hostname`
- `port`
- `close() -> boolean`
- `upgrade(req) -> boolean`

Practical meaning:

- a running server instance exposes enough state to report the bind address
- WebSocket upgrade is part of the runtime handle

## Handler Type

### `Handler`

```luau
(request: ReceivedRequest, server: Server) -> ServerResponse?
```

Important caveat:

- the return type is nullable

What to avoid:

- do not document this as a non-null-only contract

## Configuration Type

### `Configuration`

Optional fields:

- `hostname`
- `port`
- `reuseport`
- `tls`
- `handler`
- `websocket`

Practical meaning:

- the runtime supports simple handler-only startup and richer configured startup
- TLS is part of the configuration contract

## Function

### `server.serve(config: Handler | Configuration) -> Server`

Starts a server either from:

- a bare handler
- or a full configuration record

Practical meaning:

- very small servers can be started from a single function

## Example-Backed Usage

The local server example uses:

```luau
local instance = server.serve(function(_)
    return "Hello, lute!"
end)
```

Important implication from the example:

- this call is treated as non-blocking in the sample

What to avoid:

- do not assume the serve call blocks the process unless another source says so
