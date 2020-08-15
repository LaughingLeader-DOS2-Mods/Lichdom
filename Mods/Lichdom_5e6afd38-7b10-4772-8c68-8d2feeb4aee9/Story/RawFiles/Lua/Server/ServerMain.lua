function SendClientData(uuid)
	if uuid == nil then
		Ext.BroadcastMessage("LLLICH_SyncPersistentVars", Ext.JsonStringify(PersistentVars), nil)
	else
		Ext.PostMessageToClient(uuid, "LLLICH_SyncPersistentVars", Ext.JsonStringify(PersistentVars))
	end
	print("PersistentVars", Ext.JsonStringify(PersistentVars))
end

LeaderLib.RegisterListener("Initialized", function()
	SendClientData()
end)

Ext.RegisterOsirisListener("UserConnected", 3, "after", function(id, username, profileId)
	if Ext.GetGameState() == "Running" then
		Ext.PostMessageToUser(id, "LLLICH_SyncPersistentVars", Ext.JsonStringify(PersistentVars))
	end
end)
