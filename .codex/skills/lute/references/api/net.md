# `definitions/net/init.luau`

## Purpose

This definition file is an aggregator that re-exports the client and server networking surfaces under `@lute/net`.

Use this file when the question is about:

- what `@lute/net` contains at a high level
- how client-side and server-side types are grouped
- whether a type belongs to client or server networking

## What It Re-Exports

From the client side:

- `Metadata`
- `Response`
- `WebSocketOptions`
- `WebSocket`

From the server side:

- `ReceivedRequest`
- `ServerResponse`
- `Handler`
- `Configuration`
- `Server`
- `ServerWebSocket`
- `WebSocketHandlers`

## Practical Meaning

`@lute/net` is a namespace-style convenience layer:

- use the client subset for outgoing HTTP/WebSocket work
- use the server subset for serving HTTP/WebSocket traffic

This file does not define extra behavior beyond grouping those surfaces together.

## Relationship To `@std/net`

The stdlib `@std/net` wrapper currently exposes only the request-oriented subset.

Practical consequence:

- `@std/net` is not the full mirror of `@lute/net`
- for server-side APIs or client WebSockets, you may need to discuss `@lute/net/server` or `@lute/net/client` directly

## What To Avoid

- do not imply that this file introduces new request or server semantics by itself
- do not imply that the std wrapper covers all re-exported networking features
