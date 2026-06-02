# Workflows, Migration, and Alternatives

## Contents

1. Development workflow categories
2. Partial vs full management
3. Porting an existing game
4. Migrating away from Rojo
5. Alternatives and complementary tools

## Development Workflow Categories

The official docs divide Rojo usage into two broad approaches:

- partially managed Rojo
- fully managed Rojo

The workflows page is intentionally lightweight and still marked by incomplete sections, so older guidance is useful here to preserve practical tradeoffs.

The docs also frame this decision around how much of the game should remain in Team Create or similar Studio-native workflows.

## Partial vs Full Management

### Partially Managed Rojo

Definition preserved from the docs:

- Rojo manages only a slice of the project
- the rest can remain in Team Create or another system

The current docs say this is appropriate when the team mainly wants script management while leaving the rest of the game outside Rojo's control.

The older v0.5 docs add practical tradeoffs that are still useful:

Pros:

- easier incremental adoption
- integrates with Team Create

Cons:

- not everything lives in version control
- merges can be harder
- some instance categories still cannot be live-synced well, such as Terrain, MeshPart details, or CSG-related content

### Fully Managed Rojo

Definition preserved from the docs:

- Rojo manages the entire game
- the project can be built from scratch with `rojo build`

The older docs add important framing:

- this is especially practical for libraries, plugins, and simpler games
- Rojo's long-term goal was to make fully managed projects practical for more teams, even if tooling gaps still existed

Pros:

- reproducible builds from scratch
- everything can live in version control

Cons and historical caveats from the older docs:

- before stronger two-way workflows, models often had to be saved manually from Studio
- some Roblox concepts historically remained awkward or unsupported

### Team Guidance

The current workflows page suggests that in partially managed setups, each programmer should generally have their own development place.

That recommendation is important even though the rest of the section is still incomplete.

## Porting an Existing Game

The porting guide is intentionally general because every game is different.

### Preparation Advice

The docs recommend reducing Roblox-specific structure that maps poorly to the filesystem before bringing in Rojo.

Examples of structures the docs call out as awkward:

- scripts hidden inside GUI objects
- scripts embedded in scene parts
- scripts attached to Tools
- many duplicated scripts scattered through the place

The recommended refactor direction is to move code toward fewer well-known services, especially:

- `ReplicatedStorage`
- `ServerScriptService`
- `StarterPlayer`

The docs argue that this makes the codebase easier to understand, easier to navigate, and friendlier to Rojo.

They also explicitly suggest modern Roblox patterns such as `CollectionService` to replace duplicated behavior scripts.

### Porting Tools

The docs mention two concrete tools:

| Tool            | Role                                                                    |
| --------------- | ----------------------------------------------------------------------- |
| `rbxlx-to-rojo` | Most developed automation effort for converting existing games          |
| `Lune`          | Deeply customizable scripting approach for larger or more complex ports |

The docs present `Lune` as a good fit when the migration needs more bespoke control.

## Migrating Away From Rojo

The docs make an important philosophical point:

- Rojo does not lock users in

Migration away from Rojo is described as simple: resume editing the place directly in Roblox Studio instead of the filesystem.

The reason this is possible is that Rojo ultimately produces ordinary Roblox places and models.

## Alternatives and Complementary Tools

The current docs say Rojo is effectively the de-facto standard for Roblox file syncing, but still list a few alternatives to give a fuller picture:

- `Lune`
- `rbxmk`
- `Argon`
- `Lync`

The docs warn that:

- these tools are not maintained or audited by Rojo maintainers
- not every tool replaces all of Rojo's functionality

### Why Use Something Other Than Rojo?

The docs answer this directly:

- if all you need is file syncing into Studio, Rojo is usually enough
- if you need more advanced scripting or workflow customization, tools like `Lune` or `rbxmk` may offer capabilities Rojo does not

Important nuance preserved from the docs:

- Rojo can still be part of a larger toolchain
- a common workflow is to build with Rojo and then post-process the resulting `rbxl` or `rbxm` with tools such as `Lune` or `rbxmk`

That distinction matters because these tools are not always replacements; sometimes they are complementary.
