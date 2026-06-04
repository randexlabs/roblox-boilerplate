---
name: tool-docs-to-skill
description: Convert a tool, library, CLI, or SDK's scattered documentation, comments, markdown files, public type definitions, and source-level API clues into a structured Codex skill. Use when Codex needs to turn raw tool documentation into semantic `references/` files, separate public APIs into `references/apis/`, preserve caveats and troubleshooting context, and write a triggerable skill without depending on the original source paths or repository-operational details.
---

# Tool Docs To Skill

Use this skill to build a documentation-first reference skill for a specific tool. The goal is not to summarize. The goal is to preserve and reorganize the useful knowledge so future consultation is fast, complete, and practical.

## Workflow

1. Read the target material broadly before writing anything.
2. Map the developer-facing surface area.
3. Distinguish public APIs from implementation detail and repo noise.
4. Reorganize the material into semantic references.
5. Split APIs into `references/apis/` by responsibility.
6. Write the skill description so it triggers on practical user requests.
7. Validate that no meaningful API or caveat was dropped.

## Read First

- Read [references/source-hunting.md](references/source-hunting.md) to decide what to inspect.
- Read [references/output-structure.md](references/output-structure.md) before creating files.
- Read [references/preservation-rules.md](references/preservation-rules.md) while deciding what to keep.
- Read [references/api-coverage-checklist.md](references/api-coverage-checklist.md) before finalizing.

## Operating Rules

- Treat comments, markdown docs, examples, declaration files, exported modules, and author notes as potential documentation sources.
- Focus on the tool itself: what it provides, how it is used, which problems it solves, and what it exposes to the final developer.
- Ignore repository-operational material unless it is directly relevant to using the tool.
- Do not mention temporary ingestion paths, local scratch locations, or any source path that the user plans to remove later.
- Do not create scripts for the skill.
- Prefer keeping uncertain but useful context over dropping it.
- When docs and runtime disagree, record the mismatch explicitly and treat the implementation as authoritative if the public surface can be verified there.

## Deliverables

- A concise `SKILL.md` that explains how to use the generated skill and where to read more.
- A semantic `references/` tree grouped by topic rather than by source file.
- A `references/apis/` directory with APIs split by what they do, not by where they were found.
- Explicit caveats, edge cases, troubleshooting notes, and terminology that will help future debugging.

## Final Check

- Confirm that every public API discovered in docs, comments, typings, or exports appears somewhere in `references/apis/`.
- Confirm that conceptual guides and troubleshooting content were preserved outside the API files when they add value.
- Confirm that the skill can stand alone after the original raw reference material is deleted.
