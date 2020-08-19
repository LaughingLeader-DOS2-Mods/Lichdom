---@type TranslatedString
local ts = LeaderLib.Classes["TranslatedString"]

local resistedText = ts:Create("hdea60333g1649g444bgbf86g347676b8d581", "<font color='#C7A758' size='18'>Resisted [1]</font>")
local immuneText = ts:Create("h2474259fg6d67g4c98ga77fg0164f1476a41", "<font color='#FF0058' size='18'>Immune to [1]</font>")

function ApplyDomination(target, source, duration)
	if CharacterIsDead(target) == 1 then
		CharacterResurrect(target)
		ObjectSetFlag(target, "LLLICH_Dominate_WasDead", 0)
	end
	ApplyStatus(target, "LLLICH_DOMINATED", duration, 1, source)
end

local function CombatHasEnemies(target, combatid, player)
	local combatDB = Osi.DB_CombatCharacters:Get(nil, combatid)
	if combatDB ~= nil and #combatDB > 0 then
		for i,v in pairs(combatDB) do
			local char = GetUUID(v[1])
			if char ~= target and char ~= player and CharacterIsEnemy(player, char) == 1 or CharacterIsAlly(char, target) == 1 then
				return true
			end
		end
	end
	return false
end

function TryDominateUndead(target, source)
	local combatId = CombatGetIDForCharacter(target)
	if combatId ~= nil and CombatHasEnemies(GetUUID(target), combatId, GetUUID(source)) then
		local minIntResistance = Ext.ExtraData["LLLICH_DominateUndead_IntResistance"] or 14
		local intImmunity = Ext.ExtraData["LLLICH_DominateUndead_IntImmunity"] or 38
		local duration = (Ext.ExtraData["LLLICH_DominateUndead_Turns"] or 3) * 6.0
	
		local intelligence = NRD_CharacterGetComputedStat(target, "Intelligence", 0)
	
		if intelligence < minIntResistance then
			ApplyDomination(target, source, duration)
		elseif intelligence < intImmunity then
			if Ext.Random(0,100) <= 80 then
				ApplyDomination(target, source, duration)
			else
				local text = resistedText.Value:gsub("%[1%]", Ext.GetTranslatedStringFromKey(Ext.StatGetAttribute("LLLICH_TRY_DOMINATE", "DisplayName")))
				CharacterStatusText(target, text)
			end
		else
			local text = immuneText.Value:gsub("%[1%]", Ext.GetTranslatedStringFromKey(Ext.StatGetAttribute("LLLICH_TRY_DOMINATE", "DisplayName")))
			CharacterStatusText(target, text)
		end
	end
end