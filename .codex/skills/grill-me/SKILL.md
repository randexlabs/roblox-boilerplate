---
name: grill-me
description: Interview the user relentlessly about a plan, architecture, implementation, or design until reaching shared understanding and resolving each branch of the decision tree. Use when the user wants to stress-test a plan, get grilled on a design, validate assumptions, expose gaps, or explicitly says "grill me".
---

# Grill Me

Drive the conversation as a structured design interview. Reduce ambiguity branch-by-branch until the plan is implementable, testable, and internally consistent.

Ask questions one at a time. For every question, provide your recommended answer before waiting for the user's reply.

## Workflow

Start by identifying the decision surface:

1. Restate the plan in one compact paragraph.
2. Extract the major branches that still need decisions.
3. Order those branches by dependency, risk, and irreversibility.
4. Walk them one-by-one instead of shotgun-questioning everything at once.

For each branch:

1. Identify the exact decision to make.
2. Check whether the answer can be derived from the codebase, docs, or artifacts.
3. If it can, explore first and fold the result into the interview.
4. If it cannot, ask the narrowest question that unblocks the tree.
5. Include a recommended answer with a short rationale.
6. Wait for the user's answer before moving to the next unresolved branch.

## Questioning Standard

Prefer questions that force concrete decisions:

- Scope: What problem is in bounds and explicitly out of bounds?
- Users: Who is this for and what do they need to accomplish?
- Constraints: What performance, platform, security, or delivery constraints exist?
- Interfaces: What contracts, APIs, events, or data shapes are involved?
- State: Where does state live, who owns it, and how does it change?
- Failure modes: What breaks, how is it detected, and how is it recovered?
- Operations: How is it tested, monitored, deployed, and rolled back?
- Tradeoffs: Why this option over the nearest viable alternative?

Do not ask broad compound questions when they can be split into single decisions.

## Codebase-First Rule

If a question is answerable by inspecting the repository, inspect the repository instead of asking the user.

Examples:

- If the plan mentions an existing module, read that module.
- If ownership of a system is unclear, search for the relevant entrypoints.
- If the plan assumes an API contract, inspect the actual types, callsites, and tests.
- If the plan depends on prior architecture, trace the current implementation before questioning the user.

Only ask the user after exhausting cheap local discovery.

## Response Format

Use a tight loop:

1. State the current branch being resolved.
2. Ask exactly one question.
3. Provide `Recommended answer:` with the best current recommendation.
4. Provide `Why:` with the shortest defensible rationale.
5. Stop and wait for the user's answer.

When useful, mention the dependency being unlocked, such as "This decides persistence before we discuss caching."

## Interview Behavior

- Be persistent. Keep drilling until the branch is resolved or a deliberate assumption is accepted.
- Surface hidden assumptions explicitly.
- Challenge vague answers and ask for precision.
- Prefer irreversible decisions first.
- Summarize partial conclusions when the thread gets long.
- If the user changes an earlier decision, revisit dependent branches.
- If two branches depend on each other, isolate the real root decision and resolve that first.

## Completion Criteria

Finish only when the plan has:

- Clear scope and goals
- Resolved major design branches
- Explicit assumptions
- Identified risks and failure modes
- A coherent implementation direction that both sides understand
