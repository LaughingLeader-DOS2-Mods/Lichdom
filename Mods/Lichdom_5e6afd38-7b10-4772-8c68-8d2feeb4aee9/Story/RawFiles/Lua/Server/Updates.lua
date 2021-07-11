RegisterModListener("Loaded", ModuleUUID, function(l, n)
	if l < 536870912 then
		--Big shift to extender
		Osi.DB_LLLICH_Phylactery_Templates:Delete(nil,nil,nil,nil)
	end
end)