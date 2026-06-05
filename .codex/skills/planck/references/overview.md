# Overview

`Planck` is a library-agnostic scheduler for Luau and Roblox projects. It is designed to run systems:

- on specific events
- in explicit or implicit order
- behind run conditions
- through extensible plugin hooks

It is inspired by Bevy schedules and Flecs pipelines/phases, but it is not an ECS world implementation itself.

## What Planck Does

Planck gives you:

- a `Scheduler` that owns the execution graph
- `Phase` tags that mark sync points
- `Pipeline` objects that group ordered phases
- `Condition` helpers for throttling and event-driven execution
- a plugin model for debugger/tooling integration

It does not give you:

- entity storage
- queries
- components
- replication

Those come from your ECS or game architecture, such as Jecs or Matter.

## Mental Model

Think of Planck as the execution coordinator that sits above your ECS:

- your world/state are constructor arguments to `Scheduler.new(...)`
- systems are plain functions or tables that receive those same arguments
- phases say when systems run
- pipelines say how groups of phases run together
- conditions say whether a target is allowed to run this frame
- plugins wrap or observe scheduler activity for tooling and integrations

## Main Strengths

- works with different ECS libraries instead of forcing one storage model
- handles off-by-a-frame ordering problems explicitly
- supports one-time initializer systems that become normal runtime systems
- supports event grouping beyond the default update loop
- exposes a rich hook surface for plugins and debugging tools

## Package Family

Core package:

- `planck`

Official integration packages in the material you provided:

- `planck_runservice`
- `planck_jabby`

The docs also reference companion plugins for Matter hooks and Matter debugger, but those packages are not part of the source set supplied here. This skill documents the integration points they rely on, not those package internals.

## Everyday API vs Advanced API

Everyday API:

- `Scheduler.new(...)`
- `scheduler:addSystem`, `addSystems`, `removeSystem`, `replaceSystem`
- `scheduler:insert`, `insertAfter`, `insertBefore`
- `scheduler:addRunCondition`
- `scheduler:run`, `runAll`, `cleanup`
- `scheduler:getDeltaTime()`
- `Phase`, `Pipeline`
- `timePassed`, `runOnce`, `onEvent`, `isNot`
- `scheduler:addPlugin`

Advanced API:

- `scheduler.Hooks`
- `scheduler:addHook`
- call-layer hooks such as `OuterSystemCall`, `InnerSystemCall`, `SystemCall`
- runtime hook contexts and `SystemInfo`
- plugin lifecycle cleanup behavior

## Why Order Matters

Planck’s documentation centers one recurring problem: off-by-a-frame latency.

If one system mutates data and another consumes that data later than intended, the consumer may not see the change until the next frame. Planck solves this by giving you explicit execution structure rather than relying on incidental module require order or manual callback wiring.
