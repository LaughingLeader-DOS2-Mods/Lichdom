LeaderLib = Mods["LeaderLib"]
GameHelpers = LeaderLib.GameHelpers
Common = LeaderLib.Common
StringHelpers = LeaderLib.StringHelpers

Ext.RegisterListener("StatsLoaded", function()
	Ext.StatSetAttribute("LIFESTEAL", "StatusEffect", "")
end)