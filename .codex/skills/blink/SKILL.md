---
name: blink
description: Practical reference for Blink, a Luau IDL compiler for Roblox buffer networking. Use when Codex needs to answer questions about Blink schema syntax, events, functions, imports, scopes, generated Luau or TypeScript APIs, CLI usage, Studio plugin workflow, supported types, replication behavior, or doc/runtime caveats.
---

# Blink

Use this skill for practical questions about the `Blink` networking IDL and its generated Luau or TypeScript output. Favor the generated runtime behavior and parser implementation when the docs and code disagree.

## Quick Routing

- For what Blink is, what it generates, and which concepts matter first, read [references/overview.md](references/overview.md).
- For installation, first compile flow, output files, and Studio plugin usage, read [references/getting-started.md](references/getting-started.md).
- For mental models around scopes, imports, batching, polling, function yields, and generated module ownership, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For mismatches, unsupported corners, and common failure modes, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Blink language syntax, declarations, and field semantics: [references/apis/language.md](references/apis/language.md)
- Compiler options and event/function flags: [references/apis/configuration.md](references/apis/configuration.md)
- CLI commands, flags, and watch behavior: [references/apis/cli.md](references/apis/cli.md)
- Generated Luau module surface and runtime behavior: [references/apis/generated-luau.md](references/apis/generated-luau.md)
- Generated TypeScript declarations and typing caveats: [references/apis/generated-typescript.md](references/apis/generated-typescript.md)

## Working Rules

- Treat Blink as a code generator, not a runtime networking framework you call directly before generation.
- Distinguish authoring-time Blink syntax from generated Luau APIs. Many user questions confuse the schema with the emitted modules.
- Treat parser and generator behavior as authoritative when there is disagreement with the prose docs.
- Call out that Blink batches payloads into shared remotes and may expose `StepReplication` depending on options.
- Be explicit about side ownership. Client and server generated modules intentionally expose different methods.
- Mention doc/runtime mismatches when relevant, especially `Poll`, `UseColon`, polling deprecations, and exported type caveats.
