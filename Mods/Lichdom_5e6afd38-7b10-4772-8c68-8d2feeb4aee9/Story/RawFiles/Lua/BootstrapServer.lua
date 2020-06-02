Ext.Require("Shared/Init.lua")

---@type TranslatedString
local TranslatedString = LeaderLib.Classes["TranslatedString"]

-- Ext.RegisterListener("ModuleLoading", function()

-- end)
-- Ext.RegisterListener("SessionLoading", function()

-- end)
-- Ext.RegisterListener("SessionLoaded", function()

-- end)

Ext.RegisterConsoleCommand("hotbartest", function(cmd, ...)
	Ext.BroadcastMessage("LLLICH_Debug_HotbarTest", "", nil)
end)

local resistedText = TranslatedString:Create("hdea60333g1649g444bgbf86g347676b8d581", "<font color='#C7A758' size='18'>Resisted [1]</font>")
local immuneText = TranslatedString:Create("h2474259fg6d67g4c98ga77fg0164f1476a41", "<font color='#FF0058' size='18'>Immune to [1]</font>")

function TryDominateUndead(target, source)
	local minIntResistance = Ext.ExtraData["LLLICH_DominateUndead_IntResistance"] or 14
	local intImmunity = Ext.ExtraData["LLLICH_DominateUndead_IntImmunity"] or 38
	local duration = (Ext.ExtraData["LLLICH_DominateUndead_Turns"] or 3) * 6.0

	local intelligence = NRD_CharacterGetComputedStat(target, "Intelligence", 0)

	if intelligence < minIntResistance then
		ApplyStatus(target, "CHARMED", duration, 1, source)
	elseif intelligence < intImmunity then
		if Ext.Random(0,100) <= 80 then
			ApplyStatus(target, "CHARMED", duration, 1, source)
		else
			local text = resistedText.Value:gsub("%[1%]", Ext.GetTranslatedStringFromKey(Ext.StatGetAttribute("LLLICH_TRY_DOMINATE", "DisplayName")))
			CharacterStatusText(target, text)
		end
	else
		local text = immuneText.Value:gsub("%[1%]", Ext.GetTranslatedStringFromKey(Ext.StatGetAttribute("LLLICH_TRY_DOMINATE", "DisplayName")))
		CharacterStatusText(target, text)
	end
end