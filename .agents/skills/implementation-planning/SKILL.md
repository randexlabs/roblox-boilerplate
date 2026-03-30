---
name: implementation-planning
description: |
  Plan the implementation of a feature in a structured way. Use when a feature needs to be decomposed before coding: first map the main flow as a Mermaid flowchart, then identify bounded contexts, dependencies, validation points, and risks, and finally turn that into a staged implementation plan.
---

# Implementation planning

## Goal

Turn a feature request into a practical implementation plan that is easier to review, estimate, and execute.

## When to use

Use this when:

- a feature is still in planning
- the main user or system flow needs to be clarified
- implementation work spans multiple modules or concerns
- risks and dependencies should be surfaced before coding
- the team needs a staged rollout plan instead of raw brainstorming

Do NOT use this when:

- the task is already fully scoped and ready to implement
- the request is too small to justify planning overhead
- the user wants code changes immediately rather than design or planning output

## Instructions

1. Read the feature description and any relevant code or docs.
2. Define the main flow only.
   - Focus on the happy path first.
   - Add key branches only when they materially affect implementation.
3. Generate a Mermaid flowchart for that main flow.
4. Identify the bounded contexts involved.
   - Separate responsibilities by domain, subsystem, or ownership boundary.
   - Keep them concrete and implementation-relevant.
5. Identify dependencies.
   - Include internal modules, external services, data contracts, tooling, and sequencing constraints.
6. Identify validation points.
   - Include business rule checks, data integrity checks, permission checks, lifecycle guards, and test checkpoints.
7. Identify risks.
   - Include ambiguity, migration concerns, concurrency issues, failure modes, coupling, performance, and rollout hazards.
8. Convert the analysis into a staged implementation plan.
   - Order steps by dependency and risk reduction.
   - Prefer slices that can be verified independently.
9. Keep the plan actionable.
   - Each stage should have a concrete outcome, not just a topic.

## Rules

- Start with the flowchart before any analysis sections.
- Optimize for implementation planning, not product prose.
- Keep bounded contexts and dependencies distinct.
- Do not invent requirements; mark assumptions explicitly.
- Prefer a few strong validation points over exhaustive checklists.
- Call out unresolved questions when they block safe planning.
- Keep the output structured enough to hand off directly to engineering work.

## Expected output

Return the result in this order:

1. Feature summary
   - 1 short paragraph describing the feature and explicit assumptions.
2. Main flow
   - A Mermaid `flowchart` block for the primary flow.
3. Bounded contexts
   - A concise list with each context and its responsibility.
4. Dependencies
   - A concise list of internal and external dependencies.
5. Validation points
   - A concise list of checks and where they happen.
6. Risks
   - A concise list of likely implementation or rollout risks.
7. Implementation plan
   - A staged plan with ordered steps, each with a clear deliverable.

## Quality bar

A good result should:

- make the main feature flow obvious
- expose domain boundaries early
- surface blockers before implementation starts
- reduce ambiguity for whoever will build the feature
- translate analysis into an execution order that is realistic
