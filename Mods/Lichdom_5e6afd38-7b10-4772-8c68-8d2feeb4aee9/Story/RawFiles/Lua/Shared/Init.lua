LeaderLib = Mods["LeaderLib"]
GameHelpers = LeaderLib.GameHelpers
Common = LeaderLib.Common
StringHelpers = LeaderLib.StringHelpers

local WEAPONEX_EXPANSION = "c60718c3-ba22-4702-9c5d-5ad92b41ba5f"

local SkillRequirement = {
    MeleeWeapon = "MeleeWeapon",
    RangedWeapon = "RangedWeapon",
    StaffWeapon = "StaffWeapon",
    DaggerWeapon = "DaggerWeapon",
    ShieldWeapon = "ShieldWeapon",
    RifleWeapon = "RifleWeapon",
    ArrowWeapon = "ArrowWeapon",
}

local HitType = {
    Melee = "Melee",
    Magic = "Magic",
    Ranged = "Ranged",
    WeaponDamage = "WeaponDamage",
    Surface = "Surface",
    DoT = "DoT",
    Reflected = "Reflected",
}

---@param skill StatEntrySkillData
---@return string
local function GetSkillHitType(skill)
    local hitType = HitType.Magic
    if skill.UseWeaponDamage == "Yes" then
        hitType = HitType.WeaponDamage
    end
    if skill.UseCharacterStats ~= "Yes" then
        return hitType
    end
    if skill.Requirement == SkillRequirement.MeleeWeapon
    or skill.Requirement == SkillRequirement.DaggerWeapon
    or skill.Requirement == SkillRequirement.ShieldWeapon
    --or skill.Requirement == SkillRequirement.StaffWeapon -- Not used? :(
    then
        return HitType.Melee
    end
    if skill.Requirement == SkillRequirement.RangedWeapon
    or skill.Requirement == SkillRequirement.ArrowWeapon
    or skill.Requirement == SkillRequirement.RifleWeapon then
        return HitType.Ranged
    end
    return hitType
end

function IsMagicSkill(skill)
	local hitType = GetSkillHitType(skill)
	return hitType == HitType.Magic or hitType == HitType.WeaponDamage
end

Ext.RegisterListener("StatsLoaded", function()
	Ext.StatSetAttribute("LIFESTEAL", "StatusEffect", "")
	if Ext.IsModLoaded(WEAPONEX_EXPANSION) then
		local tags = Ext.StatGetAttribute("WPN_UNIQUE_LLLICH_TwinSkullGrimoire_A", "Tags") or ""
		if tags ~= "" then
			tags = tags .. ";"
		end
		tags = tags .. "LLWEAPONEX_BattleBook;LLWEAPONEX_BattleBook_Equipped"
	end
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