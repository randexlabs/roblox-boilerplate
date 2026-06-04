# Standalone API

## Purpose

The standalone bundle provides a single module that combines the main runtime API and the UI package.

## Shape

The standalone module is effectively:

```luau
local conch = require(...)

conch -- behaves like the runtime package
conch.ui -- points at the UI package
```

Implementation model:

- The returned table contains `ui`.
- Unknown keys fall through to the main runtime package via metatable `__index`.

## When To Use It

Use standalone when:

- You installed the packaged model bundle.
- You want a single require path.
- You do not want to manage separate runtime and UI requires.

## Caveat

Because it mirrors the runtime package via metatable, undocumented runtime exports are also effectively visible through standalone access.
