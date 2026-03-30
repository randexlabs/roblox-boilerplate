---
name: create-structure-docs
description: |
  Use when reorganizing raw or cloned documentation into a structured format optimized for AI usage, fast lookup, and progressive context loading.
---

# Structure documentation

## Goal

Transform raw documentation into a clean, modular, and AI-friendly structure.

## Instructions

1. Analyze the input folder (usually `docs_raw/`)
2. Do NOT copy files directly
3. Reorganize content into `docs/` with a clear structure

## Rules

- Split content into small, focused files
- Each file should represent a single concept
- Avoid large or monolithic documents
- Use descriptive and semantic file names
- Remove irrelevant content (setup, marketing, redundant text)
- Keep only useful technical/reference information

## Structure

- Group files by topic or domain
- Ensure files are independent and easy to load individually
- Avoid unnecessary cross-references

## Index

Create a `docs/index.md` file with:

- list of topics
- short description of each file
- guidance on when to use each file

## Constraints

- Prefer clarity over completeness
- Split large files aggressively
- Optimize for selective loading (progressive disclosure)

## Output

- New structured `docs/` folder
- Clean and modular documentation
- Index file
- Short explanation of decisions made
