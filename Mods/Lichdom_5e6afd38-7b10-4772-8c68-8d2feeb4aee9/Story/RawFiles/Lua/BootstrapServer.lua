if PersistentVars == nil then
	PersistentVars = {}
end

if PersistentVars.SoulReaper == nil then
	PersistentVars.SoulReaper = {}
end

Ext.Require("Shared/Init.lua")
Ext.Require("Server/Skills/DominateUndead.lua")
Ext.Require("Server/Skills/SoulReaper.lua")
Ext.Require("Server/HitListener.lua")
Ext.Require("Server/ServerMain.lua")

-- Ext.RegisterListener("ModuleLoading", function()

-- end)
-- Ext.RegisterListener("SessionLoading", function()

-- end)

Ext.RegisterConsoleCommand("hotbartest", function(cmd, ...)
	Ext.BroadcastMessage("LLLICH_Debug_HotbarTest", "", nil)
end)