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

---@param skill string
---@param caster string
---@param state SKILL_STATE
---@param data HitData
local function OnSkillHit(skill, caster, state, data)
	if IsTagged(caster, "LLLICH_TwinSkulls_EnergyMax") == 1 and IsMagicSkill(skill) then
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
		for i,v in pairs(attacker:GetSkills()) do
			local info = attacker:GetSkillInfo(v)
			if info.IsActivated and info.ActiveCooldown > 6.0 then
				local nextCooldown = math.floor(math.max(6.0, info.ActiveCooldown - 6.0))
				NRD_SkillSetCooldown(caster, v, nextCooldown)
			end
		end
		GameHelpers.UI.RefreshSkillBarCooldowns(caster)
		ClearTwinSkullsEnergy(caster)
	end
end
LeaderLib.RegisterListener("OnSkillHit", OnSkillHit)

---@type target string
---@type source string
---@type damage integer
---@type handle integer
-- local function OnPrepareHit(target, source, damage, handle)
-- 	if IsTagged(source, "LLLICH_TwinSkulls_EnergyMax") == 1 then

-- 	end
-- end
-- LeaderLib.RegisterListener("OnPrepareHit", OnPrepareHit)