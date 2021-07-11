local isClient = Ext.IsClient()

if isClient then
	---@param id string
	---@param stat CustomStatData
	---@param character EclCharacter
	---@param isVisible boolean
	local function CanDisplayLichdomStat(id, stat, character, isVisible)
		if Vars.DebugMode or character:HasTag("LLLICH_Lich") then
			return true
		elseif not isVisible then
			return false
		end
	end

	CustomStatSystem:RegisterStatVisibilityHandler("LLLICH_PhlyacteryLevel", CanDisplayLichdomStat)

	local ts = Classes.TranslatedString

	---@type table<integer,TranslatedString>
	local phylacteryEffectText = {
		[0] = ts:CreateFromKey("LLLICH_PhlyacteryLevel_None", "Your soul is not yet bound to an object."),
		[1] = ts:CreateFromKey("LLLICH_PhlyacteryLevel_Effect1", "Gain a standard Phylactery with 3 charges."),
		[2] = ts:CreateFromKey("LLLICH_PhlyacteryLevel_Effect2", "The phylactery gains 4 max charges."),
		[3] = ts:CreateFromKey("LLLICH_PhlyacteryLevel_Effect3", "The phylactery gains 5 max charges."),
		[4] = ts:CreateFromKey("LLLICH_PhlyacteryLevel_Effect4", "The phylactery gains 6 max charges."),
	}

	local phylacteryStatProgression = {
		Amulet = {
			--[0] = "LLLICH_Phylactery_Amulet",
			[1] = "LLLICH_Phylactery_Amulet",
			[2] = "LLLICH_Phylactery_Amulet_2",
			[3] = "LLLICH_Phylactery_Amulet_3",
			[4] = "LLLICH_Phylactery_Amulet_Final",
		},
		Ring = {
			--[0] = "LLLICH_Phylactery_Ring",
			[1] = "LLLICH_Phylactery_Ring",
			[2] = "LLLICH_Phylactery_Ring_2",
			[3] = "LLLICH_Phylactery_Ring_3",
			[4] = "LLLICH_Phylactery_Ring_Final",
		},
		Smallbox = {
			--[0] = "LLLICH_Phylactery_Smallbox",
			[1] = "LLLICH_Phylactery_Smallbox",
			[2] = "LLLICH_Phylactery_Smallbox_2",
			[3] = "LLLICH_Phylactery_Smallbox_3",
			[4] = "LLLICH_Phylactery_Smallbox_Final",
		},
		Jar = {
			--[0] = "LLLICH_Phylactery_Jar",
			[1] = "LLLICH_Phylactery_Jar",
			[2] = "LLLICH_Phylactery_Jar_2",
			[3] = "LLLICH_Phylactery_Jar_3",
			[4] = "LLLICH_Phylactery_Jar_Final",
		},
	}

	local ArmorBoostAttributes = {
		MagicArmorBoost = "+%s [Handle:hc6dcb940gb6b6g41aagaeceg31008af9c082:Magic Armour]",
		Necromancy = "+%s [Handle:hb7ea4cc5g2a18g416bg9b95g51d928a60398:Necromancer]",
		WaterSpecialist = "+%s [Handle:h21354580g6870g411dgbef4g52f34942686a:Hydrosophist]",
	}

	---@param character EclCharacter
	---@param stat CustomStatData
	---@param tooltip TooltipData
	Game.Tooltip.RegisterListener("CustomStat", "LLLICH_PhlyacteryLevel", function(character, customStat, tooltip)
		local element = tooltip:GetElement("AbilityDescription")
		if element then
			local value = math.min(4, customStat:GetValue(character))
			if value >= 0 then
				if value ~= 0 then
					element.CurrentLevelEffect = LocalizedText.Tooltip.AbilityCurrentLevel:ReplacePlaceholders(value, phylacteryEffectText[value].Value)
				else
					element.CurrentLevelEffect = phylacteryEffectText[value].Value
				end
				if value ~= 4 then
					element.NextLevelEffect = LocalizedText.Tooltip.AbilityNextLevel:ReplacePlaceholders(value+1, phylacteryEffectText[value+1].Value)
				end

				---@type string
				local phylacteryType = ClientData.PhylacteryType[character.NetID] or "Amulet"
				local statTable = phylacteryStatProgression[phylacteryType]
				if statTable then
					local statId = statTable[value]
					if statId then
						local stat = Ext.GetStat(statId)
						if stat then
							for attribute,valueStr in pairs(ArmorBoostAttributes) do
								local attributeValue = stat[attribute]
								if attributeValue and attributeValue > 0 then
									tooltip:AppendElement({
										Type="StatsTalentsBoost",
										Label = GameHelpers.Tooltip.ReplacePlaceholders(string.format(valueStr, attributeValue), character)
									})
								end
							end
							if value ~= 4 then
								local nextStatId = statTable[value+1]
								if nextStatId then
									local nextStat = Ext.GetStat(nextStatId)
									if nextStat then
										for attribute,valueStr in pairs(ArmorBoostAttributes) do
											local attributeValue = nextStat[attribute]
											local lastValue = stat[attribute] or 0
											local diff = attributeValue - lastValue
											if attributeValue and diff > 0 then
												if not StringHelpers.IsNullOrWhitespace(element.NextLevelEffect) then
													element.NextLevelEffect = GameHelpers.Tooltip.ReplacePlaceholders(string.format("%s<br>"..valueStr, element.NextLevelEffect, diff), character)
												else
													element.NextLevelEffect = GameHelpers.Tooltip.ReplacePlaceholders(string.format(valueStr, diff), character)
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end)
end