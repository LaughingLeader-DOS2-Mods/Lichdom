LeaderLib = Mods["LeaderLib"]
GameHelpers = LeaderLib.GameHelpers
Common = LeaderLib.Common
StringHelpers = LeaderLib.StringHelpers

Ext.RegisterListener("StatsLoaded", function()
	Ext.StatSetAttribute("LIFESTEAL", "StatusEffect", "")
end)

Ext.RegisterListener("SessionLoaded", function()
	--LeaderLib.EnableFeature("ApplyBonusWeaponStatuses")
    LeaderLib.EnableFeature("ReplaceTooltipPlaceholders")
	LeaderLib.EnableFeature("TooltipGrammarHelper")
	LeaderLib.EnableFeature("FixChaosDamageDisplay")
	LeaderLib.EnableFeature("StatusParamSkillDamage")
	LeaderLib.EnableFeature("ReduceTooltipSize")
	LeaderLib.EnableFeature("FormatTagElementTooltips")
end)