# Bounded Contexts

## Rule

Keep major domains in separate folders and modules.

## Why it matters

When `profile` and `inventory` stay isolated, work on one domain does not require loading unrelated rules from another. That reduces accidental coupling and keeps edits more local.

## Apply it here

- Put `profile` and `inventory` in separate top-level domain areas.
- Avoid importing unrelated gameplay rules into a domain just because they are nearby.
- Treat cross-domain access as an explicit boundary, not an incidental convenience.

## Good outcome

If a change only touches inventory behavior, the implementation should not need to know how buffs or other unrelated systems work.
