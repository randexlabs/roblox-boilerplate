# Roadmap And Known Gaps

The repository includes a short TODO list. These items are useful because they indicate behavior the author explicitly considers incomplete.

## Open TODO Items

### Line break handling

The TODO mentions:

- reopen colors after `\n`

Interpretation:

- nested escape restoration exists today
- newline-aware continuation is still considered unfinished

### `visible` style

Planned behavior:

- only print when color level is greater than `0`

This is not currently implemented in the public API.

### `strip` function

Planned behavior:

- remove ANSI codes from a string

This is also not currently implemented.

## Practical Guidance

If a user asks for these features:

- do not describe them as already available
- treat them as known gaps or future work
- if necessary, mention that they appear in the repo TODO rather than in the exported API
