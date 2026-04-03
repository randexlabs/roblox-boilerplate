# Serde API

Import:

```luau
local serde = require("@lune/serde")
```

## Functions

- `encode(format: EncodeDecodeFormat, value: any, pretty: boolean?) -> string`
- `decode(format: EncodeDecodeFormat, encoded: string) -> any`
- `compress(format: CompressDecompressFormat, s: string, level: number?) -> string`
- `decompress(format: CompressDecompressFormat, s: string) -> string`
- `hash(algorithm: HashAlgorithm, message: string) -> string`
  Returns a hex string.
- `hmac(algorithm: HashAlgorithm, message: string, secret: string | buffer) -> string`
  Returns a base64 string.

## Types

### `EncodeDecodeFormat`

- `"json"`
- `"yaml"`
- `"toml"`

### `CompressDecompressFormat`

- `"brotli"`
- `"gzip"`
- `"lz4"`
- `"zlib"`
- `"zstd"`

### `HashAlgorithm`

- `"md5"`
- `"sha1"`
- `"sha224"`
- `"sha256"`
- `"sha384"`
- `"sha512"`
- `"sha3-224"`
- `"sha3-256"`
- `"sha3-384"`
- `"sha3-512"`
- `"blake3"`
