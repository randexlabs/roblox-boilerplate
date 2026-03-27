# When comments are good

## Use comments to explain *why*

Comments are useful when they provide context that can’t be recovered from the code alone:

- design decisions and trade-offs (“why this approach”)
- invariants/contracts that aren’t obvious (limits, pre/post-conditions)
- platform quirks/bugs and workarounds
- performance decisions in a hot path (non-obvious choices)
- external protocols/formats (payload schema, backwards compatibility)
- traceable references (issue/PR/task identifiers)

## Avoid comments that narrate the code

Don’t add comments to describe what’s already clear from reading:

- “get X”, “do loop”, “set Y”
- “this is a function that…”

If something needs narration, prefer refactoring.

