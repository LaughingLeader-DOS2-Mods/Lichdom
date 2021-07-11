Ext.Require("Shared/_Init.lua")
Ext.Require("Client/DataListener.lua")
Ext.Require("Client/SkillParams.lua")
Ext.Require("Client/TooltipHandler.lua")

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
	
end

--Ext.RegisterListener("SkillGetDescriptionParam", SkillGetDescriptionParam)