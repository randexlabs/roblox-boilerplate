# `planck_jabby` Hook Usage

## Hook Usage

The plugin uses several core `planck` hooks:

- `SystemAdd`
- `SystemRemove`
- `SystemReplace`
- `SystemEdited`
- `SystemTriedRun`
- `SystemCall`

This matters because `SystemEdited` is not just theoretical documentation; it is actively used by the official plugin runtime.

## Startup Phase Handling

The plugin treats startup systems specially:

- startup systems are mirrored into a separate Jabby scheduler
- non-startup systems go into the normal Jabby scheduler

Startup detection is based on phase names:

- `PreStartup`
- `Startup`
- `PostStartup`

## Runtime Behavior Details

When a system tries to run but is blocked by conditions:

- the plugin marks it as paused in Jabby

When a system actually runs:

- the plugin unpauses it
- wraps the call through Jabby timing
- then invokes `context.nextFn()`

When a system changes phase:

- the plugin updates Jabby’s displayed phase metadata via the `SystemEdited` hook
