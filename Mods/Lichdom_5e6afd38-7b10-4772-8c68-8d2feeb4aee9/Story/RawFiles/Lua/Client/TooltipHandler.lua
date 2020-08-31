---@type TranslatedString
local ts = Mods.LeaderLib.Classes.TranslatedString

local LichAbility = ts:Create("hcbc6d3d0g7968g47a3gb6fcgf23c1a33d1c5", "<font color='#73F6FF'>Lichdom</font>")
local PhylacteryAbility = ts:Create("h3750ae3bg4ef4g4fc1g9362gea05305d88c6", "<font color='#73F6FF'>Lichdom</font>")
local SoulReaperRequirement = ts:Create("he95b6422g6fb0g4708g87b8g602aba339960", "Inflict Damage with a Necromancy Spell")
local ShadowDamageHelper = ts:Create("hba763a56g971dg4dd3g85a4g7eb0addf0380", "Shadow damage bypasses armor and cannot be resisted.")

---@type table<string, TranslatedString>
local AbilitySchool = {
    Target_LLLICH_ChillTouch = LichAbility,
    Shout_LLLICH_ChillForm = LichAbility,
    Target_LLLICH_DrainSoul = LichAbility,
    Target_LLLICH_DominateUndead = LichAbility,
    Shout_LLLICH_SoulReaper = LichAbility,
    Shout_LLLICH_Recall = PhylacteryAbility,
}

---@param character EclCharacter
---@param skill string
---@param tooltip TooltipData
local function OnSkillTooltip(character, skill, tooltip)
    local schoolName = AbilitySchool[skill]
    if schoolName ~= nil then
        local element = tooltip:GetElement("SkillSchool")
        if element ~= nil then
            element.Label = schoolName.Value
        end
    end
    if character:HasTag("LLLICH_TwinSkulls_EnergyMax") then
        local skillData = GameHelpers.Ext.CreateSkillTable(skill)
        if skillData["Damage Multiplier"] > 0 and IsMagicSkill(skillData) then
            local element = tooltip:GetElement("SkillDescription")
            local header = Ext.GetTranslatedStringFromKey("LLLICH_TWINSKULLS")
            local skillText = Ext.GetTranslatedString("ha05786dbg4f8eg4c23g835dge99f13aae201", "<font color='#00FFCC'>This spell with deal a guaranteed critical hit and reduce long cooldowns by 1.</font>")
            local text = string.format("<br>%s<br>%s", header, skillText)
            element.Label = element.Label .. text
            -- tooltip:AppendElement({
            --     Type = "StatusImmunity",
            --     Label = Ext.GetTranslatedString("hd7ae6af5g82eeg49ffg9c73g772609b004e0", "Guaranteed Critical Hit"),
            -- })
            -- tooltip:AppendElement({
            --     Type = "StatusImmunity",
            --     Label = Ext.GetTranslatedString("h05b6e7d1gaf93g43ccg9cb2g0115e2a1f323", "Reduce Long Cooldowns By 1"),
            -- })
        end
    end
	if skill == "Shout_LLLICH_SoulReaper" then
		local requirements = tooltip:GetElements("SkillRequiredEquipment")
		if requirements ~= nil then
			for i,element in pairs(requirements) do
				if not element.RequirementMet and string.find(element.Label, "LLLICH_CanUseSoulReaper") then
					element.Label = SoulReaperRequirement.Value
				end
			end
		end
	elseif skill == "Target_LLLICH_DrainSoul" then
        local text,_ = Ext.GetTranslatedStringFromKey("LLLICH_Tooltip_OnKill")
		local element = {
            Type = "StatusBonus",
            Label = text,
        }
        tooltip:AppendElement(element)
        text,_ = Ext.GetTranslatedStringFromKey("LLLICH_Tooltip_DrainSoulBonus1")
		element = {
            Type = "StatusImmunity",
            Label = text,
        }
        tooltip:AppendElement(element)
        text,_ = Ext.GetTranslatedStringFromKey("LLLICH_Tooltip_DrainSoulBonus2")
		element = {
            Type = "StatusImmunity",
            Label = text,
        }
        tooltip:AppendElement(element)
        if Ext.StatGetAttribute(skill, "DamageType") == "Shadow" then
            element = tooltip:GetElement("SkillProperties")
            if element ~= nil then
                table.insert(element.Properties, {
                    Label = ShadowDamageHelper.Value,
                    Warning = ""
                })
            end
        end
	end
end

local Phylactery_DisplayName = ts:Create("h5ecb6e4cg6511g45a0g81fbga80332d73ec9", "<font color='#73F6FF'>Phylactery</font>")
local Phylactery_Description = ts:Create("h84039498gaf60g4cfeg8675g5819d9a3d4c4", "<font color='#73F6FF'>The source of a Lich's immortality. Protect this at all cost.</font>") 
local Phylactery_Empty = ts:Create("hf0641549g589ag4fe0g92b8g5d955ca084d9", "<font color='#FF0000'>Out of Souls</font>")
local Phylactery_Charges = ts:Create("h36537a0bg24afg4727g9773gd4a9e1b036ed", "Souls")

local WeaponTypeTags = {
    "LLLICH_GRIMOIRE",
    "LLLICH_LICHSTAFF",
}

---@param item EclItem
---@param tooltip TooltipData
local function OnItemTooltip(item, tooltip)
    if item ~= nil then
        for i,tag in pairs(WeaponTypeTags) do
            if item:HasTag(tag) then
                local text,_ = Ext.GetTranslatedStringFromKey(tag)
                local armorSlotType = tooltip:GetElement("ArmorSlotType")
                if armorSlotType == nil then
                    armorSlotType = {
                        Type = "ArmorSlotType",
                    }
                    tooltip:AppendElement(armorSlotType)
                end
                armorSlotType.Label = text
                break
            end
        end
        if item.StatsId == "WPN_UNIQUE_LLLICH_TwinSkullGrimoire_A" then

        end
        if item:HasTag("LLLICH_Phylactery") then
            local lichIsLooking = false
            if Mods.LeaderLib.UI.ClientCharacter ~= nil then
                local character = Ext.GetCharacter(Mods.LeaderLib.UI.ClientCharacter)
                if character ~= nil then
                    lichIsLooking = character:HasTag("LLLICH_Lich")
                end
            else
                local characterStr = item:GetOwnerCharacter()
                if characterStr ~= nil then
                    local character = Ext.GetCharacter(characterStr)
                    if character ~= nil then
                        lichIsLooking = character:HasTag("LLLICH_Lich")
                    end
                end
            end
            if not lichIsLooking then
                local element = tooltip:GetElement("WandCharges")
                if element ~= nil then
                    tooltip:RemoveElements("WandCharges")
                end
            else
                local element = tooltip:GetElement("WandCharges")
                if element ~= nil then
                    element.Label = Phylactery_Charges.Value
                end
                element = tooltip:GetElement("ItemRarity")
                if element ~= nil then
                    element.Label = Phylactery_DisplayName
                end
                element = tooltip:GetElement("ItemDescription")
                if element ~= nil then
                    element.Label = Phylactery_Description.Value
                end
            end
        end
	end
end

local TwinSkullEnergyText = ts:Create("h19d156ffgaab9g4825gab62g8877197d5867", "[1]/[2] Spell Energy")
-- local TwinSkullBonusHeader = ts:Create("hbcbbad37g9cf0g463cg805fg405c55fa1e49", "Next Magical Spell Will:")
-- local TwinSkullBonusCooldowns = ts:Create("h05b6e7d1gaf93g43ccg9cb2g0115e2a1f323", "Reduce Large Cooldowns By 1")

---@param character EsvCharacter
---@param status EsvStatus
---@param tooltip TooltipData
local function TwinSkullsEnergyTooltip(character, status, tooltip)
    local energy = ClientData.TwinSkullsEnergy[character.MyGuid]
    if energy ~= nil then
        local max = Ext.ExtraData.LLLICH_TwinSkulls_MaxEnergy or 10
        if energy < max then
            tooltip:AppendElement({
                Type = "StatusBonus",
                Label = TwinSkullEnergyText:ReplacePlaceholders(energy, max)
            })
        else
            local headerText = Ext.GetTranslatedString("hbcbbad37g9cf0g463cg805fg405c55fa1e49", "<font color='#33FFCC'>The next damaging magical spell will:</font>")

            local description = tooltip:GetElement("StatusDescription")
            if description ~= nil then
                description.Label = description.Label .. "<br>" .. headerText
            end

            local cooldownText = Ext.GetTranslatedString("h05b6e7d1gaf93g43ccg9cb2g0115e2a1f323", "Reduce Long Cooldowns By 1")
            local critText = Ext.GetTranslatedString("h0a6c96bcg5d64g4226gb2eegc14f09676f65", "Critical Hit")
            tooltip:AppendElement({
                Type = "StatusBonus",
                Label = critText
            })
            tooltip:AppendElement({
                Type = "StatusBonus",
                Label = cooldownText
            })
        end

    end
end

Ext.RegisterListener("SessionLoaded", function()
    Game.Tooltip.RegisterListener("Skill", nil, OnSkillTooltip)
    Game.Tooltip.RegisterListener("Item", nil, OnItemTooltip)
    Game.Tooltip.RegisterListener("Status", "LLLICH_TWINSKULLS_ENERGY", TwinSkullsEnergyTooltip)
    Mods.LeaderLib.UI.RegisterItemTooltipTag("LLLICH_TWINSKULLS")
end)