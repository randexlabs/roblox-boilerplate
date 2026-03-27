# Guard clauses pitfalls

## Don’t hide meaningful behavior

Returning early should be the correct outcome, not a way to avoid handling errors.

## Keep guards small and local

If you need a long list of guards, consider splitting the function.

## Guard clauses vs `assert`

- Use guard clauses for expected invalid states (user input, missing instances, temporary conditions).
- Use `assert`/errors for programmer mistakes and invariants that should never happen.

