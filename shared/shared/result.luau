export type Error<Code = string> = {
	code: Code,
	message: string?,
	cause: string?,
}

export type Ok<T> = {
	ok: true,
	value: T,
}

export type Err<E> = {
	ok: false,
	error: E,
}

export type Result<T, E> = Ok<T> | Err<E>

local result = {}

function result.ok<T>(value: T): Ok<T>
	return {
		ok = true,
		value = value,
	}
end

function result.err<E>(error_payload: E): Err<E>
	return {
		ok = false,
		error = error_payload,
	}
end

return table.freeze(result)
