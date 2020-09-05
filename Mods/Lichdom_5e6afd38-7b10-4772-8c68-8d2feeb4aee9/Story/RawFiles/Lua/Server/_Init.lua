Ext.Require("Server/Skills/DominateUndead.lua")
Ext.Require("Server/Skills/SoulReaper.lua")
Ext.Require("Server/HitListener.lua")
Ext.Require("Server/ItemMechanics.lua")
Ext.Require("Server/QuestHandler.lua")

function SyncClientData(uuid)
	if uuid == nil then
		Ext.BroadcastMessage("LLLICH_SyncPersistentVars", Ext.JsonStringify(PersistentVars), nil)
	else
		Ext.PostMessageToClient(uuid, "LLLICH_SyncPersistentVars", Ext.JsonStringify(PersistentVars))
	end
	if Ext.IsDeveloperMode() then
		Ext.Print("[Lichdom] PersistentVars", Ext.JsonStringify(PersistentVars))
	end
end

LeaderLib.RegisterListener("Initialized", function()
	SyncClientData()
end)

Ext.RegisterOsirisListener("UserConnected", 3, "after", function(id, username, profileId)
	if Ext.GetGameState() == "Running" then
		Ext.PostMessageToUser(id, "LLLICH_SyncPersistentVars", Ext.JsonStringify(PersistentVars))
	end
end)