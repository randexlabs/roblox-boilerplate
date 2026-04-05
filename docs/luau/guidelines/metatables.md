# Metatables

## Avoid metatables

`Metatables` are complicated and usually not worth it.

The most common use is `__index` for classes. In Luau, that usually sacrifices `type safety`, DX, or clarity.

A simpler alternative is to use C-style functions:

```luau
type Slide = {
	length: number,
}

type Video = {
	slides: { Slide },
}
```

```luau
local function videoLength(video: Video): number
	local total = 0

	for _, slide in video.slides do
		total += slide.length
	end

	return total
end
```

This reduces `surface area`, works well with types, and keeps the code simple.

Ignoring `__index` and maybe `__tostring`, avoid almost every other `metamethod`.

## Exception - Weak tables

`Weak tables` require `__mode`.

Almost nobody needs them often. But if you do need them, this is an acceptable exception.
