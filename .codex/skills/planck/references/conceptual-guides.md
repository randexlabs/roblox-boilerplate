# Conceptual Guides

## Planck Is About Execution, Not Storage

Planck does not replace your ECS library. Its job is to express:

- when systems run
- in what order they run
- whether they should run at all this frame

This separation is central to the docs. Your systems should still make sense as systems even without Planck-specific conditions or phase tricks layered on top.

## Off-By-A-Frame Bugs

The docs repeatedly frame ordering as an optimization for correctness-feeling latency.

Pattern:

- `systemA` writes data
- `systemB` reads data
- if `systemB` runs first, it sees stale state and reacts a frame late

Planck’s answer is to move these systems into distinct phases or ordered pipelines so producer systems run before consumer systems.

## Systems Should Stay Small

The design guides push hard for:

- single responsibility
- self-contained behavior
- generic, reusable systems where possible

This matters because Planck makes execution ordering easier, but it does not rescue overly broad systems from being hard to reason about.

Practical guidance from the examples:

- split spawning, movement, and despawning into separate systems
- keep systems removable without destabilizing unrelated behavior
- pass dependencies through scheduler args instead of hard requiring globals

## Phases As Sync Points

A phase represents a sync point in execution, similar to Roblox engine loop events such as `Heartbeat` or `PreRender`.

Use a phase when:

- a system family needs to run before another family
- a sync point is meaningful in your game architecture
- startup work needs to be isolated from recurring runtime work

Avoid creating large numbers of phases without a clear structural reason.

## Pipelines As Related Ordered Phase Groups

The docs strongly recommend introducing a pipeline when multiple related phases:

- run on the same event
- always run in a meaningful sequence
- are easier to manage as one group than as many isolated inserts

Heartbeat update slices are the canonical example:

- `First`
- `PreUpdate`
- `Update`
- `PostUpdate`
- `Last`

## Ordering Model

Ordering comes from two sources:

- order of insertion
- explicit dependency edges

Phases and pipelines are ordered using Kahn’s algorithm over dependencies.
Systems inside a phase are ordered only by insertion order.

This means:

- `insert(a):insert(b)` makes `a` run before `b`
- `insertAfter(b, a)` makes `b` depend on `a`
- `insertBefore(b, a)` makes `b` run before `a`

## Event Groups

When phases/pipelines are bound to events, Planck groups them by event.

Important behavior:

- each event becomes its own group
- non-event inserts go to the default group
- groups are ordered independently
- `runAll()` runs the default group first, then event groups in creation order

This means cross-group ordering is not a dependency tool. Dependencies matter within the group, not across unrelated event groups.

## Conditions Are Filters, Not Dependencies

The condition docs are explicit here:

- run conditions should not be what makes a system logically valid
- they are for cutting unnecessary work, not encoding hidden coupling

Good uses:

- throttle expensive systems
- only react when events happened
- skip systems when a game state clearly makes them irrelevant

Bad use:

- depending on a condition to guarantee another system’s side effects already happened

## Initializer Systems

Initializer systems give one-time setup without needing a separate startup system or extra module ceremony.

Use them when setup is naturally attached to the system itself, such as:

- creating cached queries
- opening connections
- allocating helper state

They run setup once, then immediately run the returned runtime system that same execution, then use that runtime function for all later calls.

## Plugin Hooks Wrap The Scheduler

The plugin system is more than "observe a few events". It exposes:

- structural lifecycle hooks like system add/remove/replace
- execution hooks that wrap actual system calls
- phase lifecycle hooks

This allows plugins to:

- instrument run time
- integrate external runtimes like Matter topoRuntime
- feed debuggers like Jabby
- react to systems being paused by run conditions

The call-layer hook stack is especially important:

- `OuterSystemCall`
- `InnerSystemCall`
- `SystemCall`

Each wraps the next and must call `context.nextFn()` in the returned function.
