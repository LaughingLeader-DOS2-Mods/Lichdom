Ext.Require("Shared/Init.lua")

Ext.RegisterNetListener("LLLICH_Debug_HotbarTest", function(channel, payload)
	---@type UIObject
	local ui = Ext.GetBuiltinUI("Public/Game/GUI/hotBar.swf")
	ui:ExternalInterfaceCall("SlotPressed", 1, true)
end)

--- @param skill StatEntrySkillData
--- @param character StatCharacter
--- @param isFromItem boolean
--- @param param string
local function SkillGetDescriptionParam(skill, character, isFromItem, param)
	if param == "LLLICH_DominateUndead_IntResistance" then
		return math.floor(Ext.ExtraData["LLLICH_DominateUndead_IntResistance"]) or 14
	elseif  param == "LLLICH_DominateUndead_IntImmunity" then
		return math.floor(Ext.ExtraData["LLLICH_DominateUndead_IntImmunity"]) or 38
	elseif  param == "LLLICH_DominateUndead_Turns" then
		return math.floor(Ext.ExtraData["LLLICH_DominateUndead_Turns"]) or 3
	end
end

Ext.RegisterListener("SkillGetDescriptionParam", SkillGetDescriptionParam)