local task = if game then task else require '@lune/task' :: typeof(task)

export type options = {
	base_delay: number?,
	max_retries: number?,
}

return function<Result>(fn: () -> Result)
	return function(opts: options): (boolean, Result?)
		local base = opts.base_delay or 2
		local max_retries = opts.max_retries or 5
		local ok, result = false, nil
		local attempts = 0

		repeat
			ok, result = pcall(fn)
			if ok then break end

			attempts += 1
			if attempts >= max_retries then break end

			local max_wait_ceiling = base ^ attempts
			local final_wait = math.random() * max_wait_ceiling
			task.wait(final_wait)
		until ok or attempts >= max_retries

		return ok, result
	end
end
