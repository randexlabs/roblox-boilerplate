# Architecture And Patterns

## Three Core Objects

### Zones

Zones are passive spatial regions.

Key points:

- They can be static or dynamic.
- They can be created from parts, descendants, children, tags, or manually.
- They do nothing until attached to an observer.

### Groups

Groups are collections of tracked entities.

Key points:

- Every tracked entity must be in a group to be observed.
- Groups may be custom, tag-driven, all-player, or local-player specific.
- One entity can belong to multiple groups.

### Observers

Observers bridge groups and zones.

Key points:

- They subscribe to groups.
- They attach to zones or zone collections.
- They define the logic layer: events, lifecycle, transitions, and polling queries.

## Supported Usage Styles

### 1. Lifecycle

Use `observe`, `observePlayer`, `observeLocalPlayer`, or `observeGroup`.

Best for:

- UI
- music
- temporary forces or buffs
- cleanup-oriented behavior

The callback runs on enter and may return a cleanup function for exit.

### 2. Event-driven

Use:

- `onEnter`
- `onExit`
- `onPlayerEnter`
- `onPlayerExit`
- `onTransition`
- `onGroupEnter`
- `onGroupExit`

Best for one-off effects and compatibility with older zone-library mental models.

### 3. Polling / ECS

Use:

- `iterEntitiesInside`
- `iterPlayersInside`
- `iterEntitiesInZone`
- `iterZonesAtPoint`

Best for:

- data-oriented systems
- continuous per-frame effects
- deterministic stepping

If determinism matters, disable the internal scheduler and call `QuickZone:update(dt)` yourself.

## Overlapping Zone Patterns

### Data-driven transitions inside one observer

Use one observer when zones share the same logic but differ by metadata.

Behavior:

- moving between overlapping zones fires transition behavior
- pure enter/exit is not used for every switch

### State-machine style with multiple observers and priorities

Use different observers when overlapping zones represent mutually exclusive systems.

Behavior:

- higher-priority observers take control
- lower-priority observer state is exited

## Shared Zone Strategy

The examples encourage defining reusable zone sets once and letting multiple scripts subscribe to them.

Practical upside:

- no duplicated zone setup
- less mental overhead
- one shared LBVH substrate for multiple reactions
