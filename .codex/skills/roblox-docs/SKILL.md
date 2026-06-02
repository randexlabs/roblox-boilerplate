---
name: roblox-docs
description: Standardize low-friction consultation of Roblox Creator Docs from a local cached checkout of `https://github.com/Roblox/creator-docs`. Use when answering Roblox engine, API, editor, scripting, UI, networking, physics, animation, package, or platform documentation questions and when Codex should prefer a local source over repeated web calls. Also use when exact markdown wording, file paths, or source-backed lookup across Creator Docs is needed.
---

# Roblox Docs

Prefer the local `creator-docs` checkout in this skill before using web sources.

The goal is source fidelity with low friction:

- Keep the upstream markdown locally in `creator-docs/` to avoid lossy reformatting.
- Install once if missing.
- Reuse the local checkout for future queries.
- Fall back to web only when the local repo does not contain the needed information or when the user explicitly asks for a live web check.

## Workflow

1. Ensure the local cache exists:
   `python .codex/skills/roblox-docs/scripts/creator_docs.py ensure`
2. For broad topic questions, inspect the topic first:
   `python .codex/skills/roblox-docs/scripts/creator_docs.py topic "open cloud"`
3. For exact symbol lookup, use the indexed lookup first:
   `python .codex/skills/roblox-docs/scripts/creator_docs.py lookup "HumanoidDescription"`
4. Read the exact file after locating it:
   `python .codex/skills/roblox-docs/scripts/creator_docs.py show content/en-us/reference/engine/classes/HumanoidDescription.yaml`
5. Use `search` only when the answer depends on occurrences across many files:
   `python .codex/skills/roblox-docs/scripts/creator_docs.py search "HumanoidDescription"`
6. Base the answer on the raw local source whenever possible.

## Command Guide

- `ensure`
    - Clone `https://github.com/Roblox/creator-docs` into `.codex/skills/roblox-docs/creator-docs` only if it is not already installed.
- `update`
    - Refresh the existing checkout with `git pull --ff-only` when the task benefits from newer docs.
- `search <query>`
    - Search markdown, yaml, and yml files inside the local checkout.
    - Use `--regex` for regex search.
    - Use `--path-fragment` to narrow the search area.
- `lookup <query>`
    - Resolve exact or near-exact symbols to the most relevant files using the local cached index.
    - Prefer this for classes, services, enums, and specific file-like names.
- `map <query>`
    - List the most relevant local files and directories for a topic based on path names.
    - Use this before `show` when the user asks broad questions like "open cloud has what?".
- `topic <query>`
    - Show the best matching topic directory or file and print its local index content when available.
    - This is the fastest path for overview questions.
- `show <path>`
    - Print an exact local file from the cached checkout.
    - Accept a repo-relative path such as `content/en-us/reference/engine/classes/Part.yaml`.
    - Use `--line-numbers` when you need stable citations in your working notes.

## Source Handling Rules

- Prefer `show` over paraphrasing when exact API details matter.
- Prefer `topic` for overview questions and `search` for exact API/member lookup.
- Prefer `lookup` before `search` when the query looks like a class, service, enum, or named concept.
- Do not build a lossy derived index as the primary source of truth.
- Treat the cached repository contents as canonical for answers that do not require live verification.
- When summarizing, keep file paths so the source can be reopened quickly.
- If a result looks ambiguous, search again with tighter terms instead of guessing.

## Practical Notes

- Many engine API details live in YAML under `content/en-us/reference/engine/`.
- Conceptual guides, tutorials, and production docs often live elsewhere under `content/en-us/`.
- For broad "what exists here?" questions, use `topic` before deeper inspection.
- For exact symbols, use `lookup`, then open the exact file with `show`.
- Use `search` for cross-document mentions, examples, and scattered references.
- If the user asks for the latest behavior and the local checkout may be stale, run `update` before answering.
