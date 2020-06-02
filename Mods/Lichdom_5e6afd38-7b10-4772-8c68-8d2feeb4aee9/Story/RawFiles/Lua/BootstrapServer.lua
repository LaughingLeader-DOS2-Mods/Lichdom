Ext.Require("Shared/Init.lua")

---@type TranslatedString
local TranslatedString = LeaderLib.Classes["TranslatedString"]

-- Ext.RegisterListener("ModuleLoading", function()

-- end)
-- Ext.RegisterListener("SessionLoading", function()

-- end)
-- Ext.RegisterListener("SessionLoaded", function()

-- end)

Ext.RegisterConsoleCommand("hotbartest", function(cmd, ...)
	Ext.BroadcastMessage("LLLICH_Debug_HotbarTest", "", nil)
end)

