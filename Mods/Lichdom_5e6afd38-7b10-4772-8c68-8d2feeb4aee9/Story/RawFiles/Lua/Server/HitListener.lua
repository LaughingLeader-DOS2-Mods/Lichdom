local lichSkills = {
	Target_LLLICH_ChillTouch = true,
    Target_LLLICH_DrainSoul = true,
    --Shout_LLLICH_ChillForm = true,
    --Shout_LLLICH_Recall = true,
    --Target_LLLICH_DominateUndead = true,
    --Shout_LLLICH_SoulReaper = true,
}

---@type target string
---@type source string
---@type damage integer
---@type handle integer
local function OnHit(target, source, damage, handle)
	if damage > 0 
	and not StringHelpers.IsNullOrEmpty(source) 
	and IsTagged(source, "LLLICH_Lich") == 1 
	and ObjectIsCharacter(target) == 1
	then
		local skillprototype = NRD_StatusGetString(target, handle, "SkillId")
		if skillprototype ~= "" and skillprototype ~= nil then
			local skill = string.gsub(skillprototype, "_%-?%d+$", "")
			local ability = Ext.StatGetAttribute(skill, "Ability")
			if ability == "Death" or lichSkills[skill] == true then
				SoulReaper_OnNecromancySkillHit(target, source, damage, handle, skill)
			end
		end
	end
end

LeaderLib.RegisterListener("OnHit", OnHit)