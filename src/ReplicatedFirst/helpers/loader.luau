return function(container: Instance)
	for _, module_script in container:GetChildren() do
		if not module_script:IsA('ModuleScript') then continue end
		task.spawn(function()
			(require)(module_script)()
		end)
	end
end
