# Installation, Shell, and Directory Behavior

## Table of Contents

1. Read this when
2. Primary source files
3. Installation paths
4. Activation vs shims vs exec
5. Directory and trust behavior
6. Shell and editor integrations
7. Platform-specific notes
8. Debugging install/setup issues

## Read this when

Use this reference for:

- installing `mise`
- hooking it into a shell
- understanding PATH behavior
- deciding between activation, shims, and `mise exec`
- diagnosing ignored configs or trust problems
- integrating with `direnv`, IDEs, or Windows shells

## Primary source files

- `mise/README.md`
- `mise/docs/getting-started.md`
- `mise/docs/installing-mise.md`
- `mise/docs/directories.md`
- `mise/docs/direnv.md`
- `mise/docs/ide-integration.md`
- `mise/docs/faq.md`
- `mise/docs/cli/activate.md`
- `mise/docs/cli/deactivate.md`
- `mise/docs/cli/shell.md`
- `mise/docs/cli/env.md`
- `mise/docs/cli/doctor.md`
- `mise/docs/cli/doctor/path.md`
- `mise/docs/cli/trust.md`
- `mise/docs/cli/untrust.md`

## Installation paths

The repo exposes several install routes:

- quick shell installer (`curl https://mise.run | sh`)
- package managers such as Homebrew, winget, scoop, apt, dnf
- repo docs for platform-specific onboarding

Preserve the distinction between:

- installing the binary
- activating it in the shell
- installing project tools defined in config

Users often conflate these steps.

## Activation vs shims vs exec

This distinction is critical and appears explicitly in the FAQ:

- `mise activate`
    - Hooks into the interactive shell and updates PATH dynamically as directories change.
    - Best default for terminal workflows.
- `mise activate --shims`
    - Adds the shims directory once.
    - Useful for IDEs or simpler non-hook setups.
- `mise exec` / `mise x`
    - Creates a `mise`-prepared environment for a single command, then exits.
    - Good for scripts, CI, and one-offs.
- `mise env`
    - Prints environment changes for other tools to consume.
- `mise run`
    - Sets up env, then runs a named task.

When users ask "why is this command using the wrong tool?", this distinction is usually the first thing to verify.

## Directory and trust behavior

Important files and concepts:

- `mise.toml`
- `mise.local.toml`
- `.tool-versions`
- trusted vs untrusted config paths
- config roots and directory traversal

Troubleshooting prompts that should route here:

- "My config file is ignored"
- "`mise trust` seems required unexpectedly"
- "Why is this parent config affecting my repo?"
- "Why did `mise use` write to this file?"

Open these docs next:

- `mise/docs/configuration.md`
- `mise/docs/faq.md`
- `mise/docs/cli/trust.md`
- `mise/docs/cli/untrust.md`

## Shell and editor integrations

Relevant docs:

- `mise/docs/direnv.md`
- `mise/docs/ide-integration.md`
- `mise/docs/cli/completion.md`
- `mise/docs/cli/shell.md`
- `mise/docs/cli/shell-alias.md`

Important operational nuance:

- interactive shell usage and IDE/editor usage do not always want the same integration mechanism
- shims are often the simpler fit for IDEs
- shell hooks give the richest experience for terminal use

## Platform-specific notes

For Windows-specific questions, consult:

- `mise/docs/faq.md`
- `mise/docs/installing-mise.md`
- `mise/docs/ide-integration.md`

Preserve the fact that Windows support exists, but some older plugin ecosystems or shell assumptions may differ from Linux/macOS workflows.

## Debugging install/setup issues

High-value commands:

```sh
mise doctor
mise doctor path
mise env
mise which <tool>
mise config
```

Use these when the user is debugging:

- PATH mismatches
- missing tool binaries
- unexpected config resolution
- shell activation failures
- environment export issues
