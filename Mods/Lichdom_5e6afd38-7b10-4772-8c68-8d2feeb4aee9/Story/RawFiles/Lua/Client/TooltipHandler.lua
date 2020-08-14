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
    Shout_LLLICH_Recall = PhylacteryAbility,
    Target_LLLICH_DominateUndead = LichAbility,
    Shout_LLLICH_SoulReaper = LichAbility,
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

Ext.RegisterListener("SessionLoaded", function()
    Game.Tooltip.RegisterListener("Skill", nil, OnSkillTooltip)
end)