local Params = {}

---@type TranslatedString
local ts = Mods.LeaderLib.Classes.TranslatedString

local SoulReaperDescription = ts:Create("hdad53f40ge86cg489cg83cbg71baa32faef1", "Drain <font color='#FF1100'>[1] Vitality</font> from [2] (damaged by [3]).<br><font color='#CC2200'>This cannot kill the target.</font>")
local SoulReaperDisabledDescription = ts:Create("h36ae9d1cg9657g4d6dg8a86g837f45a16d00", "After using a damaging Necromancy skill, active this skill to drain half of the damage dealt from the target's Vitality.")

--- @param skill StatEntrySkillData
--- @param character StatCharacter
--- @param isFromItem boolean
--- @param param string
local function GetSoulReaperDescription(skill, character, isFromItem, param)
	if character.Character:HasTag("LLLICH_CanUseSoulReaper") and ClientData["SoulReaper"] ~= nil then
		--[1] = vitality restored
		--[2] = the last target's Name
		--[3] = the last Necromancy spell used
		---@type MessageData
		local data = ClientData["SoulReaper"][character.Character.MyGuid]
		if data ~= nil then
			local healPercentage = Ext.ExtraData["LLLICH_SoulReaper_DamageHealPercentage"] or 0.5
			local heal = math.ceil(data.Damage * healPercentage)+1
			local targetName = ""
			---@type EclCharacter
			local target = Ext.GetCharacter(data.Target)
			if target ~= nil then
				targetName = target.DisplayName
				if StringHelpers.IsNullOrEmpty(targetName) then
					targetName = data.TargetName
				end
			else
				targetName = data.TargetName
				print("Can't find target?", data.Target)
			end
			local skillName,_ = Ext.GetTranslatedStringFromKey(Ext.StatGetAttribute(data.Skill, "DisplayName"))

			print(heal, targetName, skillName, SoulReaperDescription.Value)
			return SoulReaperDescription:ReplacePlaceholders(math.ceil(heal), targetName, skillName)
		end
	end
	return SoulReaperDisabledDescription.Value
end

Params["LLLICH_SoulReaper_SkillDescription"] = GetSoulReaperDescription

--- @param skill StatEntrySkillData
--- @param character StatCharacter
--- @param isFromItem boolean
--- @param param string
local function SkillGetDescriptionParam(skill, character, isFromItem, param)
	local param_func = Params[param]
	if param_func ~= nil then
		local status,txt = xpcall(param_func, debug.traceback, skill, character, isFromItem)
		if status and txt ~= nil then
			return txt
		else
			Ext.PrintError("Error getting param (",param,") for skill",skill.Name)
			Ext.PrintError(txt)
		end
	end
end

Ext.RegisterListener("SkillGetDescriptionParam", SkillGetDescriptionParam)