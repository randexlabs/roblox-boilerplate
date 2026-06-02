# `definitions/net/client.luau`

## Purpose

This definition file describes the low-level client-side networking API exposed under `@lute/net/client`.

Use this file when the question is about:

- HTTP requests
- client-side WebSockets
- response shapes
- callback contracts for WebSocket events

## HTTP Types

### `Metadata`

Optional request metadata:

- `method: string?`
- `body: string?`
- `headers: { [string]: string }?`

Practical meaning:

- this API is flexible enough for simple GETs and explicit POST-like requests
- all metadata fields are optional

### `Response`

Fields:

- `body`
- `headers`
- `status`
- `ok`

Important caveat:

- `ok` is part of the contract, so callers do not need to infer success only from `status`

## Functions

### `client.request(url, metadata?) -> Response`

Makes an HTTP request and returns a full response record.

Practical meaning:

- minimal requests can omit metadata entirely
- richer requests can specify method, body, and headers

## WebSocket Types

### `WebSocketOptions`

Optional fields:

- `headers`
- `onopen`
- `onmessage`
- `onclose`
- `onerror`

Important caveat:

- all event handlers are optional

### `WebSocket`

Methods:

- `:send(data: string | buffer)`
- `:close()`

Important caveat:

- messages may be `string` or `buffer`

What to avoid:

- do not assume text-only payloads

## Function

### `client.websocket(url, options?) -> WebSocket`

Opens a client-side WebSocket connection.

Practical meaning:

- event-driven behavior is configured through the options callbacks

## `@std/net` Relationship

The current stdlib `@std/net` wrapper only exposes HTTP request functionality through `request(...)`.

Practical consequence:

- if the user needs WebSocket client behavior, you may need to discuss `@lute/net/client` directly
- do not imply that `@std/net` currently wraps the full WebSocket surface

## Example-Backed Usage

The local HTTP example demonstrates:

- simple GET requests
- reading `status`
- inspecting headers
- explicit POST requests with JSON body and `Content-Type`
- cooperative concurrency by combining requests with task scheduling

## What To Avoid

- do not describe `headers` or `body` as required
- do not assume WebSocket messages are always strings
