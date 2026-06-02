# `definitions/vm.luau`

## Purpose

This definition file describes the VM creation helper exposed under `@lute/vm`.

Use this file when the question is about:

- creating a new Luau VM from a module path
- isolated or separate module execution contexts

## Function

### `vm.create(path: string) -> { [any]: any }`

Creates a new Luau VM from the module at `path` and returns its exported table.

## Practical Meaning

This is a very loose contract:

- the returned value is a generic table
- the definition does not preserve precise module return typing

Practical consequence:

- this is more of a dynamic runtime hook than a strongly typed module-import API

## What To Avoid

- do not present `vm.create` as preserving exact static type information
- do not over-promise isolation semantics beyond “new Luau VM from the module at path” unless another source confirms more
