export type Error<Code = string> = {
	code: Code,
	message: string?,
	cause: string?,
}

local Result = {}

function Result.ok<T>(value: T): (true, T)
	return true, value
end

function Result.err<E>(error_payload: E): (false, E)
	return false, error_payload
end

return table.freeze(Result)
