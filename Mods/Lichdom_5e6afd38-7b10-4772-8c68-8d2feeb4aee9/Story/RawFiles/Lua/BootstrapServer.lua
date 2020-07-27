PersistentVars = {}
PersistentVars["SoulReaper"] = {}

Ext.Require("Shared/Init.lua")
Ext.Require("Server/Skills/DominateUndead.lua")
Ext.Require("Server/Skills/SoulReaper.lua")

-- Ext.RegisterListener("ModuleLoading", function()

-- end)
-- Ext.RegisterListener("SessionLoading", function()

-- end)

Ext.RegisterConsoleCommand("hotbartest", function(cmd, ...)
	Ext.BroadcastMessage("LLLICH_Debug_HotbarTest", "", nil)
end)