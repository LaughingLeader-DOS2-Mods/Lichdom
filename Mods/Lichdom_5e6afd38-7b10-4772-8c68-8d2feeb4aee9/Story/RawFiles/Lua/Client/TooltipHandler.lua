---@type TranslatedString
local ts = Mods.LeaderLib.Classes.TranslatedString

local LichAbility = ts:Create("hcbc6d3d0g7968g47a3gb6fcgf23c1a33d1c5", "<font color='#73F6FF'>Lichdom</font>")
local PhylacteryAbility = ts:Create("h3750ae3bg4ef4g4fc1g9362gea05305d88c6", "<font color='#73F6FF'>Lichdom</font>")
local SoulReaperRequirement = ts:Create("he95b6422g6fb0g4708g87b8g602aba339960", "Inflict Damage with a Necromancy Spell")

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
	if skill == "Shout_LLLICH_SoulReaper" then
		local requirements = tooltip:GetElements("SkillRequiredEquipment")
		if requirements ~= nil then
			for i,element in pairs(requirements) do
				if not element.RequirementMet and string.find(element.Label, "LLLICH_CanUseSoulReaper") then
					element.Label = SoulReaperRequirement.Value
				end
			end
		end
	end
end

local Phylactery_DisplayName = ts:Create("<font color='#73F6FF'>Phylactery ([1])</font>	h5ecb6e4cg6511g45a0g81fbga80332d73ec9")
local Phylactery_Description = ts:Create("h84039498gaf60g4cfeg8675g5819d9a3d4c4", "<font color='#73F6FF'>The source of a Lich's immortality. Protect this at all cost.</font>") 
local Phylactery_Empty = ts:Create("hf0641549g589ag4fe0g92b8g5d955ca084d9", "<font color='#FF0000'>Out of Souls</font>")
local Phylactery_Charges = ts:Create("h36537a0bg24afg4727g9773gd4a9e1b036ed", "Souls")

---@param item EclItem
---@param tooltip TooltipData
local function OnItemTooltip(item, tooltip)
    if item ~= nil and item:HasTag("LLLICH_Phylactery") then
        print(item.StatsId, Ext.JsonStringify(item.WorldPos), Ext.JsonStringify(tooltip.Data))
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
            element = tooltip:GetElement("ItemName")
            if element ~= nil then
                element.Label = Phylactery_DisplayName:ReplacePlaceholders(StringHelpers.Trim(element.Label))
            end
            element = tooltip:GetElement("ItemDescription")
            if element ~= nil then
                element.Label = Phylactery_Description.Value
            end
        end
	end
end

Ext.RegisterListener("SessionLoaded", function()
    Game.Tooltip.RegisterListener("Skill", nil, OnSkillTooltip)
    Game.Tooltip.RegisterListener("Item", nil, OnItemTooltip)
end)