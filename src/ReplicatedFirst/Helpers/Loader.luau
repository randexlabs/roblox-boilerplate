return function(container: Instance)
	for _, moduleScript in container:GetChildren() do
		if not moduleScript:IsA('ModuleScript') then continue end
		task.spawn(function()
			(require)(moduleScript)()
		end)
	end
end
