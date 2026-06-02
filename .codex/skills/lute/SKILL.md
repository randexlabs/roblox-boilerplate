---
name: lute
description: Answer practical Lute questions using reorganized local documentation. Use when working with Lute installation, the `lute` CLI, `@std` and `@lute` libraries, testing, linting, code transforms, Docker usage, editor setup, build/bootstrap flows, contribution guidance, or release-process details.
---

# Lute

Use this skill when the user needs source-based guidance about how Lute works in practice.

Start with the topic-matched file in `references/`. Read only the files that match the task, but preserve caveats, examples, warnings, operational notes, and author intent when answering.

## Workflow

1. Identify whether the task is about usage, tooling, libraries, build/dev workflow, or project operations.
2. Open the smallest matching reference file first.
3. Keep important distinctions explicit:
    - `Luau` language builtins vs Lute runtime capabilities
    - `@std` portable higher-level libraries vs `@lute` runtime-specific builtins
    - end-user CLI usage vs contributor/build workflows
    - stable releases vs nightly builds
4. Preserve useful context instead of flattening it into an API catalog.
5. When the question involves maintenance or historical behavior, read `references/build-contributing-and-release.md` before answering confidently.

## Reference Map

- `references/index.md`
    - Human-readable map of the reorganized corpus and source coverage.
- `references/overview-getting-started-and-tutorials.md`
    - What Lute is, installation paths, first-run setup, Hello World, the guessing-game walkthrough, and the testing tutorial.
- `references/cli-reference.md`
    - Top-level CLI usage plus `run`, `check`, `compile`, `setup`, `test`, and `transform`.
- `references/linting-and-rules.md`
    - `lute lint`, config shape, rule loading, output modes, and the built-in lint rules currently documented.
- `references/code-transforms-and-program-analysis.md`
    - Conceptual and practical transform guidance, including query-based and visitor-based CST workflows.
- `references/runtime-and-library-model.md`
    - The Lute library model, `@std`, `@lute`, portability guidance, and standard-library/runtime positioning.
- `references/runtime-definitions-and-caveats.md`
    - Cross-cutting guidance for reading definition files correctly, especially annotation semantics and `@lute` vs `@std` caveats.
- `references/api/crypto.md`
    - `definitions/crypto.luau`: hashing, secretbox, password hashing, and misuse caveats.
- `references/api/fs.md`
    - `definitions/fs.luau`: low-level filesystem API, open modes, metadata, watcher semantics, and `@std/fs` differences.
- `references/api/io.md`
    - `definitions/io.luau`: raw stdin/stdout plus how `@std/io` adds prompting.
- `references/api/luau.md`
    - `definitions/luau.luau`: parsing, CSTs, compile/load, module resolution, and type introspection.
- `references/api/net-client.md`
    - `definitions/net/client.luau`: HTTP requests and client WebSockets.
- `references/api/net.md`
    - `definitions/net/init.luau`: top-level `@lute/net` aggregation and client/server surface map.
- `references/api/net-server.md`
    - `definitions/net/server.luau`: HTTP server handlers, responses, and server WebSockets.
- `references/api/process.md`
    - `definitions/process.luau`: argv, env, child processes, shells, stdio, and signals.
- `references/api/system.md`
    - `definitions/system.luau`: host/platform/memory/CPU introspection and std wrapper behavior.
- `references/api/task.md`
    - `definitions/task.luau`: cooperative scheduling, wait/delay semantics, and std wrapper differences.
- `references/api/time.md`
    - `definitions/time.luau`: `Instant`, `Duration`, constructors, arithmetic, and scalar-return caveats.
- `references/api/vm.md`
    - `definitions/vm.luau`: VM creation and loose typing caveats.
- `references/examples-and-recipes.md`
    - Example-driven usage patterns grouped by workflow, including filesystem, process, task/time, networking, tests, docs generation, and type-introspection examples.
- `references/docker-and-distribution.md`
    - Container images, tags, recommended Docker invocations, and reproducibility guidance.
- `references/build-contributing-and-release.md`
    - Building with `luthier`, bootstrap flow, toolchain-manager workflow, manual builds, docs generation, contribution guidance, and release operations.

## Usage Notes

- For first-project help, start with `overview-getting-started-and-tutorials.md` and `cli-reference.md`.
- For `lute test` questions, combine `overview-getting-started-and-tutorials.md` with `cli-reference.md`.
- For `lute lint` usage, rule behavior, or config shape, start with `linting-and-rules.md`.
- For CST/query/visitor transform work, open `code-transforms-and-program-analysis.md` first, then `cli-reference.md` if command syntax matters.
- For `@std` vs `@lute` questions, start with `runtime-and-library-model.md`.
- For low-level runtime API questions based on type definitions, start with `runtime-definitions-and-caveats.md` and then open the matching file in `references/api/`.
- For `fs` questions, combine `api/fs.md` with `examples-and-recipes.md` and keep the `@lute/fs` vs `@std/fs` distinction explicit.
- For `process` questions, combine `api/process.md` with `examples-and-recipes.md`.
- For `task` or `time` questions, combine `api/task.md` or `api/time.md` with `examples-and-recipes.md`.
- For `io` questions, combine `api/io.md` with the user-input examples in `examples-and-recipes.md`.
- For Luau parser/CST/type-introspection questions, start with `api/luau.md`, then use `code-transforms-and-program-analysis.md` or `examples-and-recipes.md` if practical examples help.
- For “how is this used in practice?” questions, start with `examples-and-recipes.md`.
- For Docker or install/distribution questions, combine `docker-and-distribution.md` with `overview-getting-started-and-tutorials.md`.
- For build, contributor, or release-process questions, start with `build-contributing-and-release.md`.

## Resources

- `references/`
    - Topic-grouped Lute documentation reorganized for fast lookup while preserving practical context.
