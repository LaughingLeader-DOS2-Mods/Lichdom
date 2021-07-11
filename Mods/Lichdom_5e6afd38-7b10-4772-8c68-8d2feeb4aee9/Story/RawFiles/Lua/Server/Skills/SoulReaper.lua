---@type TranslatedString
local ts = Classes.TranslatedString

local SoulReaperCombatText = ts:Create("h034f0136g2489g4549g996eg282f817c215d", "[1] drained <font color='#97FBFF'>[2] Vitality</font> from [3] with [Key:Shout_LLLICH_SoulReaper_DisplayName].")

---@param center EsvCharacter
---@param radius number
---@param prioritizeParty boolean
---@param prioritizeLowHealth boolean
local function FindClosestCharacter(center, radius, prioritizeParty, prioritizeLowHealth)
	local lastDist = radius+0.1
	local lastVit = -1
	local lastScore = -1
	local targets = {}
	for i,v in pairs(center:GetNearbyCharacters(radius)) do
		if v ~= center.MyGuid and CharacterIsAlly(v, center.MyGuid) == 1 and CharacterIsDead(v) == 0 then
			local targetChar = Ext.GetCharacter(v)
			if targetChar ~= nil then
				local score = 0
				local dist = GetDistanceTo(center.MyGuid, v)
				if dist < lastDist then
					score = score + 1
				end
				if prioritizeLowHealth == true then
					if targetChar.Stats.CurrentVitality < targetChar.Stats.MaxVitality then
						score = score + 1
						if lastVit == -1 then
							lastVit = targetChar.Stats.CurrentVitality
						elseif targetChar.Stats.CurrentVitality < lastVit then
							score = score + 2
							lastVit = targetChar.Stats.CurrentVitality
						end
					end
				end
				if prioritizeParty == true and CharacterIsInPartyWith(v, center.MyGuid) == 1 then
					score = score + 1
				end
				table.insert(targets, {Target=v, Score=score})
			end
		end
	end
	if #targets > 0 then
		table.sort(targets, function(a,b)
			return a.Score > b.Score
		end)
		return targets[1].Target
	end
	return nil
end

---@param skill string
---@param char string
---@param state SKILL_STATE PREPARE|USED|CAST|HIT
---@param skillData SkillEventData|HitData
local function OnSoulReaperSkill(skill, char, state, skillData)
	if state == SKILL_STATE.CAST then
		if IsTagged(char, "LLLICH_CanUseSoulReaper") == 1 then
			ClearTag(char, "LLLICH_CanUseSoulReaper")
			GameHelpers.UI.SetSkillEnabled(char, "Shout_LLLICH_SoulReaper", false)
		end

		local last = LichdomPersistentVars.SoulReaper[GetUUID(char)]
		if last ~= nil and last.Damage ~= nil then
			local healPercentage = Ext.ExtraData["LLLICH_SoulReaper_DamageHealPercentage"] or 0.5
			local heal = math.ceil(last.Damage * healPercentage)
			local healVal = math.tointeger(-1 * (heal))
			local handle = nil
			local casterObj = Ext.GetCharacter(char)
			local beamTarget = char
			if casterObj.Stats.CurrentVitality >= casterObj.Stats.MaxVitality then
				local target = FindClosestCharacter(casterObj, 16.0, true, true)
				if target == nil then target = char end
				handle = NRD_HitPrepare(target, char)
				beamTarget = target
			else
				handle = NRD_HitPrepare(char, char)
			end
			NRD_HitSetInt(handle, "SimulateHit", 0)
			NRD_HitSetInt(handle, "HitType", 1)
			NRD_HitSetInt(handle, "NoHitRoll", 1)
			NRD_HitSetInt(handle, "CriticalRoll", 2)
			NRD_HitSetInt(handle, "ProcWindWalker", 0)
			NRD_HitSetInt(handle, "ForceReduceDurability", 0)
			NRD_HitSetInt(handle, "HighGround", 2)
			NRD_HitSetInt(handle, "Reflection", 0)
			--NRD_HitSetInt(handle, "LifeSteal", heal*-1)
			NRD_HitSetInt(handle, "FromSetHP", 1)
			NRD_HitSetInt(handle, "DontCreateBloodSurface", 1)
			NRD_HitSetInt(handle, "NoDamageOnOwner", 1)
			NRD_HitSetInt(handle, "NoEvents", 1)
			NRD_HitAddDamage(handle, "None", healVal)
			NRD_HitExecute(handle)

			if last.Target ~= nil and ObjectExists(last.Target) == 1 then
				local sourceChar = Ext.GetCharacter(char)
				local targetChar = Ext.GetCharacter(last.Target)

				local sourcename = sourceChar.DisplayName
				if CharacterIsControlled(char) == 1 then
					sourcename = string.format("<font color='#00A2FD'>%s</font>", sourceChar.DisplayName)
				end

				local targetname = last.TargetName
				if CharacterIsEnemy(char, last.Target) == 1 then
					targetname = string.format("<font color='#D7001F'>%s</font>", targetChar.DisplayName)
				elseif CharacterIsPartyMember(last.Target) == 1 then
					targetname = string.format("<font color='#00A2FD'>%s</font>", targetChar.DisplayName)
				elseif CharacterIsAlly(char, last.Target) == 1 then
					targetname = string.format("<font color='#11D77A'>%s</font>", targetChar.DisplayName)
				else
					targetname = string.format("<font color='#F3D347'>%s</font>", targetChar.DisplayName)
				end

				GameHelpers.UI.CombatLog(SoulReaperCombatText:ReplacePlaceholders(sourcename, heal+1, targetname), 0)

				PlayEffect(beamTarget, "RS3_FX_Skills_Soul_Cast_Beam_Soul_Body_01", "Dummy_BodyFX")
				PlayEffect(last.Target, "RS3_FX_Skills_Soul_Cast_Beam_Soul_Root_01", "Dummy_Root")
				if CharacterIsDead(last.Target) == 1 then
					PlayBeamEffect(last.Target, beamTarget, "RS3_FX_GP_Beams_ShadowBeam_01", "Dummy_Root", "Dummy_BodyFX")
				else
					PlayBeamEffect(last.Target, beamTarget, "RS3_FX_GP_Beams_ShadowBeam_01", "Dummy_BodyFX", "Dummy_BodyFX")
					if targetChar ~= nil then
						local nextHealth = math.max(1, targetChar.Stats.CurrentVitality - heal)
						if nextHealth ~= targetChar.Stats.CurrentVitality then
							local enemyHit = NRD_HitPrepare(last.Target, char)
							NRD_HitSetInt(enemyHit, "SimulateHit", 0)
							NRD_HitSetInt(enemyHit, "HitType", 1)
							NRD_HitSetInt(enemyHit, "NoHitRoll", 1)
							NRD_HitSetInt(enemyHit, "CriticalRoll", 2)
							NRD_HitSetInt(enemyHit, "ProcWindWalker", 0)
							NRD_HitSetInt(enemyHit, "ForceReduceDurability", 0)
							NRD_HitSetInt(enemyHit, "HighGround", 2)
							NRD_HitSetInt(enemyHit, "Reflection", 0)
							NRD_HitSetInt(enemyHit, "FromSetHP", 0)
							NRD_HitSetInt(enemyHit, "DontCreateBloodSurface", 1)
							NRD_HitSetInt(enemyHit, "NoDamageOnOwner", 1)
							NRD_HitSetInt(enemyHit, "DamagedVitality", 1)
							NRD_HitSetInt(enemyHit, "NoEvents", 1)
							NRD_HitSetInt(enemyHit, "Blocked", 0)
							NRD_HitSetInt(enemyHit, "Dodged", 0)
							NRD_HitSetInt(enemyHit, "Missed", 0)
							NRD_HitSetInt(enemyHit, "ArmorAbsorption", 0)
							NRD_HitSetInt(enemyHit, "LifeSteal", 0)
							NRD_HitSetInt(enemyHit, "HitWithWeapon", 0)
							NRD_HitAddDamage(enemyHit, "None", targetChar.Stats.CurrentVitality - nextHealth)
							--print("Soul Reaper damage:", targetChar.Stats.CurrentVitality - nextHealth)
							NRD_HitExecute(enemyHit)

							local text,_ = Ext.GetTranslatedStringFromKey("LLLICH_StatusText_SoulReaperVictim")
							text = string.gsub(text, "%[1%]", math.ceil(targetChar.Stats.CurrentVitality - nextHealth))
							CharacterStatusText(last.Target, text)
						end
					end
				end
			end
			LichdomPersistentVars.SoulReaper[char] = nil
			SyncClientData(char)
		end
	end
end
RegisterSkillListener("Shout_LLLICH_SoulReaper", OnSoulReaperSkill)

---@param target string
---@param source string
---@param damage integer
---@param handle integer
---@param skill string
function SoulReaper_OnNecromancySkillHit(target, source, damage, handle, skill)
	if CharacterHasSkill(source, "Shout_LLLICH_SoulReaper") == 1 then
		local targetChar = Ext.GetCharacter(target)
		LichdomPersistentVars.SoulReaper[source] = {
			Damage = damage,
			Skill = skill,
			Target = target,
			TargetName = targetChar.DisplayName
		}
		SyncClientData(source)
		SetTag(source, "LLLICH_CanUseSoulReaper")
		GameHelpers.UI.SetSkillEnabled(source, "Shout_LLLICH_SoulReaper", true)
	end
end