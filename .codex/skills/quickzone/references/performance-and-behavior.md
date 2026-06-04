# Performance And Behavior

## Why It Scales

QuickZone is designed around an entity-centric model rather than a zone-centric one.

That means:

- adding more zones is comparatively cheap
- entity count and observer settings dominate cost
- the library avoids physics-engine collision overhead

## Static Vs Dynamic Zones

QuickZone maintains two trees:

- static LBVH
- dynamic LBVH

Use static zones for fixed geometry.
Use dynamic zones for moving or resizing regions.

Why it matters:

- updating static zones forces static-tree rebuild work
- dynamic zones rebuild a smaller tree
- promoting or demoting a zone between static and dynamic rebuilds both trees

## Auto Sync

Auto-sync is for zones that follow references such as moving parts or attachments.

Behavior:

- if `setAutoSync(true)` is used on a static zone, the zone is automatically made dynamic
- base parts also watch size changes
- `Part` instances additionally watch shape changes
- attachments and bones sync world transform only

## Frame Budget

QuickZone budget is expressed in milliseconds at the public API, but converted to seconds internally.

Example:

```luau
QuickZone:setFrameBudget(0.5)
```

Meaning:

- QuickZone will try to stop work once the frame budget is reached
- heavy workloads are smeared across frames instead of causing spikes

Tradeoff:

- lower stutter
- possible latency between movement and event delivery under load

## Precision

Observer precision is a movement threshold in studs.

QuickZone only re-evaluates an entity when it moves more than that threshold.

Higher precision:

- reduces query frequency
- improves performance
- can delay detection of small movements

## Update Rate

Observer update rate is per-observer, in Hz.

Higher update rates:

- lower latency
- more CPU use

Lower update rates:

- less CPU use
- more latency

## Safety Mode

Observer safety defaults to true.

Meaning:

- callbacks are wrapped in `task.spawn`
- this is safer for yielding code
- it trades some overhead for protection

With safety off:

- callbacks run directly
- yielding can break QuickZone
- only use it when you want the lower overhead and can guarantee non-yielding callbacks

## Point-based Limitation

QuickZone tracks one representative point for each entity, not full entity volume.

This is a feature for speed, but also an important semantic limit:

- a large part can visually intersect a zone while its tracked point is still outside
- attachments or bones can intentionally represent specific offsets such as weapon tips
