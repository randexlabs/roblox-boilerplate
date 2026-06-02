# Versioning and History

## Contents

1. Default version stance
2. Rojo 6 to Rojo 7 upgrade notes
3. Legacy v0.5 guidance worth preserving
4. Historical maintenance notes

## Default Version Stance

When answering Rojo questions, default to the current documentation set unless one of these is true:

- the repo clearly targets an older Rojo major version
- the user explicitly mentions Rojo 6 or older
- the question references legacy syntax or historical docs

This matters because some syntax and workflows changed over time while other concepts remained stable.

## Rojo 6 to Rojo 7 Upgrade Notes

The upgrade guide says Rojo 7 is mostly backward compatible with Rojo 6, but it highlights one important breaking area: explicit property syntax in project and meta files.

### What Did Not Change

Implicit property syntax stayed the same.

Example:

```json
{
    "name": "cool-skateboard",
    "tree": {
        "$className": "Part",
        "$properties": {
            "Material": "Wood",
            "Size": [2, 0.5, 6],
            "Color": [1, 0, 0],
            "CFrame": [0, 10, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]
        }
    }
}
```

The docs strongly recommend using implicit syntax whenever possible because it is shorter, easier to read, and more future-proof.

### What Changed

In Rojo 6, explicit properties used a `Type` and `Value` object pair.

Rojo 6 example:

```json
{
    "name": "cool-skateboard",
    "tree": {
        "$className": "Part",
        "$properties": {
            "Material": {
                "Type": "Enum",
                "Value": 512
            },
            "Size": {
                "Type": "Vector3",
                "Value": [2, 0.5, 6]
            }
        }
    }
}
```

In Rojo 7, those fields were folded together into the current single-key representation.

Rojo 7 example:

```json
{
    "name": "cool-skateboard",
    "tree": {
        "$className": "Part",
        "$properties": {
            "Material": {
                "Enum": 512
            },
            "Size": {
                "Vector3": [2, 0.5, 6]
            }
        }
    }
}
```

The docs also note that some types, including `CFrame` and `ColorSequence`, had field changes in the explicit format.

### Upgrade Guidance Preserved From the Docs

- prefer implicit syntax when possible
- use `rbxm` / `rbxmx` files for more complicated models instead of hand-writing every property

## Legacy v0.5 Guidance Worth Preserving

Older docs contain practical advice that still helps frame adoption decisions even if some issue numbers or limitations are historical.

### Full vs Partial Management

The old `full-vs-partial` page is still useful for:

- pros and cons of each adoption style
- reproducibility vs ease of migration
- the reality that some content types historically fit partial management better

### Meta Files

The current sync docs still preserve the key concept that meta files were introduced in Rojo 0.5. This is useful historical context when older repos mention `.meta.json` as a newer feature.

### Older Installation Differences

The older v0.5 installation docs used `Foreman` rather than `Rokit` as the highlighted toolchain path. That is useful only when maintaining old setup docs or old CI workflows.

## Historical Maintenance Notes

The blog content adds light but useful project context:

### New Website

The Rojo website was rebuilt on Docusaurus. This is mostly historical context and not operational guidance.

### New Maintainers

The 2023 maintenance post explains:

- the original author stepped away from the Roblox ecosystem
- Rojo later gained active maintainers again
- the Studio plugin is now published by a Roblox group rather than the original author's account

Practical implication preserved from the post:

- this change only matters for users who are not letting Rojo manage the plugin for them

That maintenance note can help explain why old plugin links or assumptions may not match current distribution.
