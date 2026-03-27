---

name: create-skill
description: | Use when identifying a repeated workflow, reusable capability, or structured task that should be turned into a portable skill.
---

---

# Create skill

## Goal

Turn a repeated workflow, task pattern, or documented process into a reusable skill.

## When to use

Use this when:

- a task is repeated often
- the same prompt pattern is being reused
- a workflow has clear inputs, rules, and outputs
- documentation describes a process that could be operationalized
- an existing manual process should become a reusable skill

Do NOT use this when:

- the task is one-off
- the behavior is too vague or exploratory
- the process depends heavily on project-specific context and cannot be generalized

## Instructions

When asked to create a skill:

1. Analyze the source material
    - this may be a workflow, prompt, conversation, documentation, or repeated task

2. Identify:
    - the skill purpose
    - when it should be triggered
    - what inputs it expects
    - what constraints it should follow
    - what output it should produce

3. Decide whether the process should really become a skill
    - if not, explain why briefly instead of forcing it

4. If it should become a skill:
    - generate a complete skill in markdown format
    - keep it reusable and focused
    - avoid unnecessary project-specific details unless explicitly required

## Skill design rules

- The skill must represent one clear capability
- Keep the scope narrow and operational
- Prefer reusable wording over project-specific wording
- Use descriptive trigger language in the description
- Avoid giant instructions or monolithic skills
- Prefer clarity over completeness
- The skill should be understandable without extra explanation

## Required output structure

When generating a skill, include:

1. Frontmatter
    - name
    - description

2. A short title

3. Goal section

4. When to use section

5. Instructions section

6. Rules or constraints section

7. Expected output section

## Output requirements

- Return the final skill as a complete markdown file
- Also include a short explanation of:
    - why this should be a skill
    - what problem it solves
    - what made you scope it this way

## Quality bar

A good generated skill should:

- be reusable
- be discoverable by description
- have a single clear responsibility
- improve consistency
- reduce repeated prompting
