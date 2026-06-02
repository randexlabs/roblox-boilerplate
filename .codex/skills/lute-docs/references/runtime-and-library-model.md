# Runtime and Library Model

## Core Product Positioning

Lute exists to make Luau viable for general-purpose programming outside game engines and other embedded hosts.

The docs consistently frame that goal around "interaction with the outside world," including:

- file-system access
- network requests
- sockets
- process management
- cryptography
- source analysis and code manipulation

## Two Main Library Layers

| Layer  | Implementation | Purpose                                                         |
| ------ | -------------- | --------------------------------------------------------------- |
| `lute` | C++            | Core runtime libraries and foundational capabilities.           |
| `std`  | Luau           | Higher-level standard library built on top of runtime features. |

## `@std` vs `@lute`

This distinction matters in practical answers.

### `@std`

`@std` is the higher-level standard library. The docs position it as:

- more featureful than bare Luau
- intended to feel broadly usable across general-purpose Luau runtimes
- the preferred default when possible

The docs also indicate a portability ambition:

- these APIs are intended to be shared across runtimes where feasible
- the project hopes this interface can eventually be supported broadly, including Roblox-facing ecosystems

### `@lute`

`@lute` exposes runtime-native libraries implemented as part of the executable.

These APIs provide foundational capabilities such as:

- file-system access
- network access
- access to Luau internals

### Portability Guidance

The generated docs make an explicit recommendation:

- prefer `@std` where practical
- using `@lute` directly makes code less portable
- `@lute` APIs are not expected to exist in Roblox or other non-Lute environments

## Luau Builtins vs Lute APIs

The tutorial docs explicitly separate:

- Luau builtins such as `math.random`, `string`, `buffer`, and other primitive-oriented libraries
- Lute APIs for environment interaction such as terminal input, files, and HTTP

This distinction is important when answering questions about whether something is "part of Lute" or "part of Luau."

## Standard Library Snapshot

The current generated `@std` index in the local docs is short but it still communicates the intended positioning:

- `@std` is the common utility layer users will almost certainly want for general-purpose work
- it exists to make Luau practical beyond embedded sandbox contexts

## Runtime Builtins Snapshot

The current generated `@lute` index is also brief but includes a crucial warning:

- `@lute` contains foundational, native runtime libraries
- these powers are what the higher-level standard library is built on
- they should generally be treated as lower-level and less portable than `@std`

## Repository Structure Context

The contributor docs add useful orientation for future debugging:

- source code for runtime functionality lives under the runtime source tree
- type definitions live in the definitions area
- user-facing docs live in the docs area
- tooling lives in the tools area
- tests live in the tests area

That layout helps explain where answers might need to be verified when the docs are thin.
