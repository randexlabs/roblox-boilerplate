# Getting Started

## Basic Counter

```luau
local create = vide.create
local source = vide.source

local function Counter()
    local count = source(0)

    return create "TextButton" {
        Text = function()
            return "count: " .. count()
        end,

        Activated = function()
            count(count() + 1)
        end,
    }
end
```

This shows the three most common Vide patterns:

- `source()` stores mutable reactive state.
- `create()` constructs instances declaratively.
- a property assigned a function becomes a reactive property update, unless the property is an event.

## Mounting A Component

Use `mount()` when you want a top-level stable scope and optionally want the result applied to an existing instance:

```luau
local function App()
    return create "ScreenGui" {
        create "TextLabel" {
            Text = "Vide",
        },
    }
end

local destroy = vide.mount(App, game.Players.LocalPlayer.PlayerGui)
```

Call `destroy()` to tear down the mounted scope.

## Property And Child Rules

Inside a `create()` property table:

- string keys set instance properties
- string keys with function values either connect events or create reactive property effects
- numeric keys add children, nested child tables, actions, or reactive child producers

Example:

```luau
return create "Frame" {
    Size = UDim2.fromScale(1, 1),

    Activated = function()
        print("clicked")
    end,

    create "UICorner" {},

    function()
        return create "TextLabel" {
            Text = "Reactive child",
        }
    end,
}
```

## When To Use Which Reactive Primitive

- Use `source()` for writable state.
- Use `derive()` for cached computed values read more than once between updates.
- Use `effect()` for side effects.
- Use `read()` when a value may or may not be a source.
- Use `batch()` when several source writes should flush together.

## Control Flow Helpers

- Use `show()` for truthy/falsey conditional rendering.
- Use `switch()` when one key selects one component from a mapping.
- Use `indexes()` when identity is the table key/index.
- Use `values()` when identity is the table value itself and items may reorder.

`values()` is the better fit for reordering stable objects such as players, inventory items, chat messages, or toast entries.
