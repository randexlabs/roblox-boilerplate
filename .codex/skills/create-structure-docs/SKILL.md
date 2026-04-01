---
name: create-structure-docs
description: Reorganize raw, cloned, or vendor documentation into a modular `docs/` tree optimized for AI lookup, selective loading, and long-term maintenance. Use when Codex needs to convert large or messy documentation sets into curated indexes, topic folders, and focused markdown files instead of keeping monolithic source material.
---

# Structure Documentation

## Audit the source

Inspect the incoming documentation set before editing anything.
Identify the main domains, repeated themes, noisy content, and the files that are too broad to stay intact.

## Restructure deliberately

Create or update a `docs/` tree that favors small, focused files over large documents.
Group content by topic, domain, or subsystem so each file can be loaded independently.
Do not copy raw files verbatim when they contain setup noise, marketing text, duplicated material, or mixed concerns.

## Keep only useful reference material

Preserve technical concepts, APIs, workflows, constraints, schemas, and behavior notes.
Remove boilerplate setup prose, promotional language, repeated examples, and content that does not help future task execution.

## Optimize for selective loading

Split aggressively when a file covers multiple concepts.
Prefer descriptive filenames that make the content obvious without opening the file.
Avoid deep cross-references when a cleaner topic split would work better.

## Maintain the index

Create or refresh `docs/index.md`.
List each major topic area, summarize what it contains, and state when that topic should be consulted.

## Output contract

Produce a curated `docs/` structure with:

- focused markdown files
- clear topic indexes
- minimal redundancy
- a short note on major organization decisions
