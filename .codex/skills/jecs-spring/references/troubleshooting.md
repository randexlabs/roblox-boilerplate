# Troubleshooting

## Nothing Animates

Check the integration order:

- `jecs_spring.world(world)` must run before using `jecs_spring.goal`, `jecs_spring.options`, `jecs_spring.motion`, or `jecs_spring.completed`
- `jecs_spring.system(delta)` must actually run every frame
- the entity must have a goal pair for the component you expect to animate

Also verify that the component value you want to animate is the same component id used as the pair target.

## The Value Jumps Immediately Instead Of Interpolating

This can happen when the base component did not have an initial value before the goal was added.

The implementation creates the spring from:

```luau
start or goal
```

If `start` is missing, the spring starts at the goal, so there is nothing to interpolate.

Set the initial component value first if you want visible motion from a known origin.

## My Spring Options Did Not Apply To The First Motion

Set `pair(options, component)` before the first `pair(goal, component)` when possible.

The implementation does handle options that change later, but initializing options first avoids starting the spring under default settings and then reconfiguring it afterward.

## Querying Completed Returns Unexpected Entities

This is a real implementation caveat.

`pair(completed, component)` is added to:

- the animated gameplay entity
- an internal controller entity created by `jecs-spring`

So a query like:

```luau
for entity in world:query(pair(jecs_spring.completed, c.size)) do
	...
end
```

can include controller entities as well.

Safer approaches:

- filter by one of your own gameplay marker components
- validate that the entity is one you own before deleting or mutating it
- avoid assuming every completed-match entity is the visible animated object

## The README Completion Example Is Risky

The README shows deleting every entity returned by a completed query.

That can also delete internal controller entities, because the implementation marks them with the same completed pair. Deleting controllers may be harmless in some flows, but the example is broader than it looks and should not be treated as proof that only target entities are returned.

## Rebinding A Different World Breaks Existing Expectations

The module keeps global mutable state.

If another caller runs `world(otherWorld)`, all generated ids and query state are rebound. Systems still holding the old ids or assuming the old world is active will stop behaving correctly.

## I Changed The Goal But Completion Stayed Set

The implementation explicitly removes completed markers when the goal changes, but only if the motion exists and the new goal is different from `motion.state.goal`.

If your query still sees completion:

- verify that you actually changed the goal value
- verify that a motion object exists for that component
- verify that you are not reading the internal controller entity instead of the gameplay entity
