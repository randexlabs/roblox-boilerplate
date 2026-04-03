# CLI

## Run scripts

```sh
lune run script-name
```

Search order for `script-name`:

- current directory
- `./lune`
- `./.lune`
- `~/lune`
- `~/.lune`

Lune prefers `.luau`, also supports `.lua`.
Passing an absolute file path skips name lookup.

## List scripts

```sh
lune list
```

Lists scripts found in `lune` and `.lune`, including top-level `-->` description comments.

## Run from stdin

```sh
echo "print('Hello')" | lune run -
```
