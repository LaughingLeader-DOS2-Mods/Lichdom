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

RegisterListener("OnHit", OnHit)


local function RefreshSkillCooldowns(uuid)
	local cooldowns = {}
	local char = Ext.GetCharacter(uuid)
	for i,v in pairs(char:GetSkills()) do
		local info = char:GetSkillInfo(v)
		if info.ActiveCooldown > 0 then
			cooldowns[v] = info.ActiveCooldown
		end
	end
	CharacterResetCooldowns(uuid)
	for skill,cd in pairs(cooldowns) do
		print(skill,cd)
		NRD_SkillSetCooldown(uuid, skill, cd)
	end
end

local function TwinSkullsBonus(skill, caster, state, data)
	local attacker = Ext.GetCharacter(caster)
	if NRD_StatusGetInt(data.Target, data.Handle, "CriticalHit") == 0 then
		local target = Ext.GetCharacter(data.Target).Stats
		NRD_HitStatusClearAllDamage(data.Target, data.Handle)
		local hit = GameHelpers.Damage.CalculateSkillDamage(skill, attacker.Stats, target, data.Handle, false, true, true)
		GameHelpers.Damage.ApplyHitRequestFlags(hit, data.Target, data.Handle)
		for i,damage in pairs(hit.DamageList:ToTable()) do
			NRD_HitStatusAddDamage(data.Target, data.Handle, damage.DamageType, damage.Amount)
		end
		NRD_StatusSetInt(data.Target, data.Handle, "CriticalHit", 1)
	end
	NRD_StatusSetInt(data.Target, data.Handle, "Hit", 1)
	NRD_StatusSetInt(data.Target, data.Handle, "Dodged", 0)
	NRD_StatusSetInt(data.Target, data.Handle, "Missed", 0)
	NRD_StatusSetInt(data.Target, data.Handle, "Blocked", 0)

	local hasSkillCooldowns = false
	local skillCooldowns = {}
	for i,v in pairs(attacker:GetSkills()) do
		if v ~= skill then
			local info = attacker:GetSkillInfo(v)
			if info.ActiveCooldown >= 12.0 then
				local nextCooldown = math.floor(info.ActiveCooldown - 6.0)
				NRD_SkillSetCooldown(caster, v, 0.0)
				skillCooldowns[v] = nextCooldown
				hasSkillCooldowns = true
				-- local slots = GameHelpers.Skill.GetSkillSlots(caster, v)
				-- for i,slot in pairs(slots) do
				-- 	NRD_SkillBarClear(caster, slot)
				-- 	NRD_SkillBarSetSkill(caster, slot, v)
				-- end
			end
		end
	end
	if hasSkillCooldowns then
		Timer.StartOneshot("LLLICH_FixSkillCooldown_"..skill..caster, 50, function()
			for v,cd in pairs(skillCooldowns) do
				NRD_SkillSetCooldown(caster, v, cd)
			end
		end)
	end
	--GameHelpers.UI.RefreshSkillBarCooldowns(caster)
	--RefreshSkillCooldowns(caster)
	ClearTwinSkullsEnergy(caster)
	return true
end

---@param skill string
---@param caster string
---@param state SKILL_STATE
---@param data HitData
local function OnSkillHit(skill, caster, state, data)
	if IsTagged(caster, "LLLICH_TwinSkulls_EnergyMax") == 1 and IsMagicSkill(skill) then
		local b,err = xpcall(TwinSkullsBonus, debug.traceback, skill, caster, state, data)
		if not b then
			print(err)
		end
	end
end
RegisterListener("OnSkillHit", OnSkillHit)

---@type target string
---@type source string
---@type damage integer
---@type handle integer
-- local function OnPrepareHit(target, source, damage, handle)
-- 	if IsTagged(source, "LLLICH_TwinSkulls_EnergyMax") == 1 then

-- 	end
-- end
-- RegisterListener("OnPrepareHit", OnPrepareHit)