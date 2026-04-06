# Temporary Character State

Guidance for short-lived gameplay state such as `stunned`, `running`, `crouching`, cooldown flags, and similar character or mob state.

## Avoid

- `Folder`, `ValueObject`, or other Instance creation/destruction for temporary state
- non-script objects inside `StarterCharacterScripts` for state markers
- replicated temporary state in `Workspace` or `ReplicatedStorage` when other clients do not consume it
- repeated `:FindFirstChild()` / `.Value` chains as a hot-path state API

## Why

- Instance creation and destruction is materially more expensive than plain table state.
- ValueObjects, Instances, and Attributes replicate when placed in replicated hierarchies, which wastes bandwidth when the state is server-only.
- Repeated child lookup for transient state adds avoidable latency and frame cost in hot paths.
- Non-script character payload in `StarterCharacterScripts` scales badly on games with frequent character resets and is especially bad in competitive games with frequent state churn.

## StarterCharacterScripts Constraint

Do not use `StarterCharacterScripts` as a container for non-script state markers.

Reasons:

- every character reset recreates that payload
- reset spam turns that cost into a server problem
- Roblox has historical character cleanup issues, so this pattern compounds memory pressure instead of containing it

## Preferred State Model

Use plain Luau tables and internal non-replicated state by default.

- keep authoritative temporary state on the server in domain-owned tables
- replicate only the subset that another client actually needs
- if replication is required, prefer explicit remotes or a narrow runtime boundary over ambient replicated objects
- if a replicated scalar must exist, a pre-created value container is less bad than churn from creating and deleting Instances repeatedly

## Practical Rule

If nobody outside the authority path consumes the state, do not replicate it.

For most character state, other clients need appearance and movement outcomes, not the full internal flag set, cooldown state, or combat bookkeeping.
