# Net API

Import:

```luau
local net = require("@lune/net")
```

## Core functions

- `request(urlOrOptions: string | RequestOptions) -> Response`
  Sends an HTTP request.
- `serve(port: number, handler: (request: Request) -> ResponseLike) -> never`
  Starts an HTTP server.
- `socket(url: string) -> WebSocket`
  Opens a WebSocket connection.

## TCP

- `tcp.connect(host: string, port: number) -> TcpStream`

### `TcpStream`

- `read(chunkSize: number?) -> string?`
- `write(data: string | buffer) -> ()`
- `close() -> ()`

## Common response fields

- `ok: boolean`
- `statusCode: number`
- `statusMessage: string`
- `headers: {[string]: string}`
- `body: string`
