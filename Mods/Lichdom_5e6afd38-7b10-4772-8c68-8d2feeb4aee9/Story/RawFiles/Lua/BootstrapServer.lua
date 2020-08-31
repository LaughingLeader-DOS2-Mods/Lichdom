if PersistentVars == nil then
	PersistentVars = {}
end

if PersistentVars.SoulReaper == nil then
	PersistentVars.SoulReaper = {}
end
if PersistentVars.TwinSkullsEnergy == nil then
	PersistentVars.TwinSkullsEnergy = {}
end

Ext.Require("Shared/Init.lua")
Ext.Require("Server/_Init.lua")

-- Ext.RegisterListener("ModuleLoading", function()

-- end)
-- Ext.RegisterListener("SessionLoading", function()

-- end)

Ext.RegisterConsoleCommand("hotbartest", function(cmd, ...)
	Ext.BroadcastMessage("LLLICH_Debug_HotbarTest", "", nil)
end)