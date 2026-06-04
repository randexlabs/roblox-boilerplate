# Conceptual Guides

## Scope Model

Vide has two scope kinds.

### Stable scopes

Created by APIs such as:

- `root()`
- `untrack()`
- component bodies created through dynamic helpers like `show()`, `switch()`, `indexes()`, and `values()`

Stable scopes:

- do not track source reads
- do not rerun automatically
- may create both stable and reactive child scopes

### Reactive scopes

Created by:

- `effect()`
- `derive()`
- implicit effects created by `create()` property and child bindings

Reactive scopes:

- track sources they read
- rerun on updates
- may not directly create other reactive scopes

The common escape hatch is to insert a stable scope with `untrack()` or `root()`.

## Cleanup Ownership

Cleanup runs when a scope reruns or is destroyed.

- `cleanup()` can register callbacks, disconnectables, destroyables, and threads.
- nested scopes are owned by the scope that created them
- destroying a parent scope destroys its owned descendants

This is why effects and dynamically created UI usually clean themselves up correctly when created through Vide primitives instead of ad hoc imperative code.

## Implicit Effects

Vide turns certain `create()` table entries into reactive behavior automatically.

- A non-event string property with a function value becomes a reactive property effect.
- A numeric child slot with a function value becomes a reactive child effect.
- Removed children are unparented automatically when that child effect reruns or is destroyed.

This keeps component code concise, but it also means those callbacks inherit the no-yield rule of reactive scopes.

## Dynamic Scopes

Dynamic helpers create and destroy stable scopes in response to source updates.

- `show()` toggles a stable subtree on truthiness.
- `switch()` keeps scopes keyed by the selected value.
- `indexes()` tracks identity by table key/index.
- `values()` tracks identity by table value.

Delayed destruction is supported by returning a number after the component result. During the delay window:

- the old scope may stay alive
- a new scope may also exist
- outputs may temporarily contain multiple objects instead of one

That behavior is important for transitions and exit animations.

## Reactive Graph Mental Model

Think of Vide as a graph:

- sources are data nodes
- effects and derives are reactive computation nodes
- stable scopes own lifetime but do not themselves track updates

If a bug looks like stale UI, duplicate listeners, or surprise destruction, the first questions are:

1. Which scope owns this work?
2. Is this code running in a stable or reactive scope?
3. Did a source read create a dependency edge you did not intend?
4. Was cleanup registered in the same scope that created the resource?
