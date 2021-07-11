Mods.LeaderLib.ImportUnsafe(Mods.Lichdom)

---@class LichdomPersistentVars
DefaultLichdomPersistentVars = {
	SoulReaper = {},
	TwinSkullsEnergy = {},
	PhylacteryType = {}
}

MODID = {
	WEAPONEX_EXPANSION = "c60718c3-ba22-4702-9c5d-5ad92b41ba5f"
}

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
	if type(skill) == "string" then
		if string.find(skill, "LLLICH_") then
			return true
		end
		skill = GameHelpers.Ext.CreateSkillTable(skill)
	elseif string.find(skill.Name, "LLLICH_") then
		return true
	end
	local hitType = GetSkillHitType(skill)
	return hitType == HitType.Magic or hitType == HitType.WeaponDamage
end

Ext.RegisterListener("StatsLoaded", function()
	Ext.StatSetAttribute("LIFESTEAL", "StatusEffect", "")
	if Ext.IsModLoaded(MODID.WEAPONEX_EXPANSION) then
		local tags = Ext.StatGetAttribute("WPN_UNIQUE_LLLICH_TwinSkullGrimoire_A", "Tags") or ""
		if tags ~= "" then
			tags = tags .. ";"
		end
		tags = tags .. "LLWEAPONEX_BattleBook;LLWEAPONEX_BattleBook_Equipped"
	end
end)

Ext.RegisterListener("SessionLoaded", function()
	--LeaderLib.EnableFeature("ApplyBonusWeaponStatuses")
    EnableFeature("ReplaceTooltipPlaceholders")
	EnableFeature("TooltipGrammarHelper")
	EnableFeature("FixChaosDamageDisplay")
	EnableFeature("StatusParamSkillDamage")
	EnableFeature("ReduceTooltipSize")
	EnableFeature("FormatTagElementTooltips")
end)

Ext.Require("Shared/CustomStats.lua")