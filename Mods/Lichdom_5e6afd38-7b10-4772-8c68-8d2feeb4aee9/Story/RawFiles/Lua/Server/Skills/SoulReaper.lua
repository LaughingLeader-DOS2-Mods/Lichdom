SKILL_STATE = LeaderLib.SKILL_STATE

---@param skill string
---@param char string
---@param state SKILL_STATE PREPARE|USED|CAST|HIT
---@param skillData SkillEventData|HitData
local function OnSoulReaperSkill(skill, char, state, skillData)
	if state == SKILL_STATE.CAST then
		local last = PersistentVars["SoulReaper"][char]
		if last ~= nil and last.Damage ~= nil then
			local healPercentage = Ext.ExtraData["LLLICH_SoulReaper_DamageHealPercentage"] or 0.5
			local heal = -1 * math.ceil(last.Damage * healPercentage)
			local handle = NRD_HitPrepare(char, char)
			if last.Target ~= nil and ObjectExists(last.Target) == 1 then
				if CharacterIsDead(last.Target) == 1 then
					PlayBeamEffect(last.Target, char, "LLLICH_FX_Beams_Domination_Apply_01", "Dummy_Root", "Dummy_BodyFX")
				else
					PlayBeamEffect(last.Target, char, "LLLICH_FX_Beams_Domination_Apply_01", "Dummy_BodyFX", "Dummy_BodyFX")
				end
			end
			NRD_HitSetInt(handle, "SimulateHit", 0)
			NRD_HitSetInt(handle, "HitType", 1)
			NRD_HitSetInt(handle, "NoHitRoll", 1)
			NRD_HitSetInt(handle, "CriticalRoll", 2)
			NRD_HitSetInt(handle, "ProcWindWalker", 0)
			NRD_HitSetInt(handle, "ForceReduceDurability", 0)
			NRD_HitSetInt(handle, "HighGround", 2)
			NRD_HitSetInt(handle, "Reflection", 0)
			NRD_HitSetInt(handle, "FromSetHP", 1)
			NRD_HitAddDamage(handle, "None", heal)
			NRD_HitExecute()
		end
		ClearTag(char, "LLLICH_CanUseSoulReaper")
		PersistentVars["SoulReaper"][char] = nil
	end
end
LeaderLib.RegisterSkillListener("Shout_LLLICH_SoulReaper", OnSoulReaperSkill)

---@param target string
---@param source string
---@param damage integer
---@param handle integer
---@param skill string
function SoulReaper_OnNecromancySkillHit(target, source, damage, handle, skill)
	if CharacterHasSkill(source, "Shout_LLLICH_SoulReaper") == 1 then
		PersistentVars["SoulReaper"][source] = {
			Damage = damage,
			Skill = skill,
			Target = Ext.GetCharacter(target).NetID
		}
		SendClientData(source)
		SetTag(source, "LLLICH_CanUseSoulReaper")
		GameHelpers.UI.SetSkillEnabled(source, "Shout_LLLICH_SoulReaper", true)
	end
end