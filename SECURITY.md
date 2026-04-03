# Security Policy

## Scope

This repository includes:

- Roblox server and client code under `src/`
- Lune-based tooling and scripts
- local test infrastructure
- third-party packages resolved through `pesde` and Wally

Security issues are in scope when they can affect confidentiality, integrity, or availability of:

- player data
- server authority
- developer machines running local tooling
- CI or release workflows

## Sensitive Surfaces

Treat these areas as security-sensitive by default:

- `ServerScriptService` runtime code
- profile/session/data persistence flows
- Lune scripts with filesystem, process, or network access
- CLI tooling such as `re-test`
- dependency resolution, package updates, and generated scripts

## Out Of Scope

The following are usually not security vulnerabilities by themselves:

- style issues
- performance-only issues without abuse impact
- editor-only configuration problems
- crashes in local-only dev scripts that do not create privilege, data, or integrity risk

## Reporting

Do not report vulnerabilities through public issues or public pull requests.

Report privately to the maintainer through a private GitHub security report if available.
If that is not available, contact the maintainer directly through a private channel before disclosure.

Include:

- affected file or subsystem
- impact
- reproduction steps
- assumptions or required permissions
- suggested fix if you have one

## Disclosure

- prefer coordinated disclosure
- avoid publishing proof-of-concept exploits before a fix is available
- keep reports private until the maintainer confirms disclosure timing

## Supported Fixes

Security fixes are expected to target the active development line first.
Older revisions may not receive patches unless the maintainer explicitly decides to backport them.
