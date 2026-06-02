# `definitions/crypto.luau`

## Purpose

This definition file describes the low-level crypto API exposed under `@lute/crypto`.

Use this file when the question is about:

- hashing
- symmetric authenticated encryption via secretbox
- password hashing and verification

## Hashing

### Algorithm Tokens

Available exported algorithm tokens:

- `md5`
- `sha1`
- `sha256`
- `sha512`
- `blake2b256`

Practical meaning:

- the API expects typed algorithm tokens, not arbitrary free-form strings

What to avoid:

- do not document `digest` as taking algorithm names typed by hand unless you also show the exported token objects

### `crypto.digest(hash, message) -> buffer`

Computes a cryptographic hash over:

- `string`
- or `buffer`

Returns a `buffer`.

Important caveat:

- this is content hashing, not password storage

## Secretbox

### `SecretBox`

Readonly fields:

- `ciphertext`
- `nonce`
- `key`

Practical meaning:

- the returned box carries everything needed for later decryption, including the key field

### `crypto.secretbox.keygen() -> buffer`

Generates a new secret key.

### `crypto.secretbox.seal(message, key?) -> SecretBox`

Encrypts a message using:

- a provided key
- or a fresh key if omitted

Important caveat:

- omitting the key is convenient for demos, but later decryption requires preserving the returned key

What to avoid:

- do not recommend “omit the key” for durable encryption workflows unless the answer explicitly says to persist the returned key

### `crypto.secretbox.open(box) -> buffer`

Decrypts the sealed box and returns the plaintext as a buffer.

## Password Hashing

### `crypto.password.hash(password) -> buffer`

Hashes a password using a slow, memory-hard algorithm suitable for password storage.

### `crypto.password.verify(hash, password) -> boolean`

Verifies a password against a stored hash.

Practical meaning:

- this is purpose-built for credential verification, not generic content hashing

What to avoid:

- do not use password hashing as a normal digest replacement

## Example-Backed Usage

The local crypto examples cover:

- secretbox encryption/decryption flows
- password hashing flows
- hashing examples

Those examples should be combined with this file when the user asks for concrete usage patterns.
