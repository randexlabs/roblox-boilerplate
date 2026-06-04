# Troubleshooting And Caveats

## Documentation And Runtime Drift

The available material is not perfectly synchronized. The most important mismatches are:

- `conch.args` docs and typings say `enum_new` and `enum_map`; runtime exports `enum_from_array` and `enum_from_map`.
- The built-in type table still mentions `userinput`, but the current runtime export table does not expose `args.userinput`.
- Published runtime docs list fewer default commands than the current bootstrap actually registers.
- `conch.log()` docs mention four log kinds, but the runtime also accepts `"success"`.
- The runtime exports additional fields such as `cancel`, `log_to`, `version`, `console`, `get_strange_type`, `register_strange_type`, `pluralize_type`, and `wrap_type`, which are not front-and-center in the main docs.
- `conch_ui` typings only cover `bind_to`, `mount`, `opened`, and `app`, but the runtime also exports `alignment`, `theme`, `focused`, and a nested `conch` reference.

## Client-Only Behavior

These runtime APIs are client-only in practice:

- `conch.execute()` asserts client mode and requires a local user.
- `conch.set_var()` asserts client mode.
- `conch_ui.mount()` and `conch_ui.bind_to()` are client UI concerns.

If you try to use them on the server, expect assertion failures or missing state.

## Command Context Limitations

`conch.get_command_context()` is thread-local. It is designed to be read during command execution.

Implications:

- It is reliable inside command callbacks.
- It should not be assumed to exist in arbitrary asynchronous work after context has been popped.
- Server logging helpers only auto-route to the active executor when a command context exists.

## Custom Type Registration Order

Custom and replicated argument types must exist on both client and server before related commands are registered. If not:

- Analysis suggestions may be incomplete on the client.
- Replicated command type data may arrive without matching local strange-type handlers.
- The client may warn that a type id is unregistered.

## Parser Behavior

The parser is usually called behind `pcall`.

Reason:

- Parse failures are surfaced as structured issue data, but the parse function may throw that structure instead of returning it normally.

If you consume AST APIs directly, treat parsing as a protected call boundary.

## Plugin API Caveats

- The plugin API only works in Studio.
- `plugin_api.expose()` only serializes tables.
- Recursive tables are rejected.
- Functions are bridged via `BindableFunction`.
- Signals are bridged via `BindableEvent`.
- The copy of `plugin_api.load()` bundled under the UI package appears to return `process({}, folder)` instead of `process({}, front.folder)`. Treat direct use of that specific helper as suspect and verify behavior against the runtime you are targeting.

## Helper Caveats From Runtime

- `args.intersect()` currently constructs a type tagged as `"intersect"` while the surrounding type system uses `"intersection"`. Treat it as a runtime discrepancy until verified in the target version.
- `args.struct()` appears to have a questionable `value` assignment path when both `indexer` and `value` are provided. If indexed table typing matters, test the exact behavior instead of trusting the helper blindly.
- `player` and `userid` suggestion flows support special selectors such as `@s`; pluralized variants add `@a` and sometimes `@o`.
- Duration parsing accepts several misspelled suffix spellings such as `milisecond` and `miliseconds` because that is what the runtime recognizes.

## Safe Answering Strategy

When answering future questions:

- Prefer “runtime exports” over “published docs say”.
- If a user asks for a helper by a stale name, mention the mismatch and offer both names.
- If a behavior depends on client/server side, call that out explicitly.
