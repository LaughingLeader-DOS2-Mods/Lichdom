local Params = {}

---@type TranslatedString
local ts = Mods.LeaderLib.Classes.TranslatedString

--- @param skill StatEntrySkillData
--- @param character StatCharacter
--- @param isFromItem boolean
--- @param param string
local function GetSoulReaperDescription(skill, character, isFromItem, param)
	if ClientData["SoulReaper"] ~= nil then
		---@type MessageData
		local data = ClientData["SoulReaper"][character.Character.MyGuid]
		if data ~= nil then
			local description,_ = Ext.GetTranslatedStringFromKey("Shout_LLLICH_SoulReaper_Description_Enabled")
			local healPercentage = Ext.ExtraData["LLLICH_SoulReaper_DamageHealPercentage"] or 0.5
			local heal = (data.Params.Damage * healPercentage)
			description = description:gsub("%[1%]", Ext.GetTranslatedStringFromKey(Ext.StatGetAttribute(data.Params.Skill, "DisplayName")))
			description = description:gsub("%[2%]", string.format("%i", math.ceil(heal)))
			return description
		end
	end
	local description,_ = Ext.GetTranslatedStringFromKey("Shout_LLLICH_SoulReaper_Description_Disabled")
	return description
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
		if status then
			if txt ~= nil then
				return txt
			end
		else
			Ext.PrintError("Error getting param ("..param..") for skill:\n",txt)
			return ""
		end
	end
end

Ext.RegisterListener("SkillGetDescriptionParam", SkillGetDescriptionParam)