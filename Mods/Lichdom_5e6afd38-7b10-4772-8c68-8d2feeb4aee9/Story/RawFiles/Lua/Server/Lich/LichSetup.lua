local self = LichSystem

---@param player EsvCharacter
function LichSystem:SetRaceTag(player)
	for race,undead in pairs(self.Settings.TagSwap) do
		if player:HasTag(race) then
			SetTag(player.MyGuid, undead)
		end
	end
	SetTag(player.MyGuid, "UNDEAD")
end

---@param player EsvCharacter
function LichSystem:AddSkills(player)
	local uuid = player.MyGuid
	if player:HasTag("UNDEAD") and not player:HasTag("LLLICH_Lich") then
		ObjectSetFlag(uuid, "LLLICH_LichRaceOriginallyUndead", 0)
	end
	local addedSkills = {}
	for skill,level in pairs(self.Settings.Skills.LichForm) do
		if level == 0 and CharacterHasSkill(uuid, skill) == 0 then
			local stat = Ext.GetStat(skill)
			if stat then
				CharacterAddSkill(uuid, skill, 0)
				table.insert(addedSkills, GameHelpers.GetStringKeyText(stat.DisplayName, stat.DisplayNameRef))
			end
		end
	end
	for tag,data in pairs(self.Settings.Skills.Racial.Races) do
		if (player:HasTag(tag) or CharacterHasSkill(uuid, data.Original) == 1) and CharacterHasSkill(uuid, data.Replace) == 0 then
			local stat = Ext.GetStat(data.Replace)
			if stat then
				CharacterAddSkill(uuid, data.Replace, 0)
				table.insert(addedSkills, GameHelpers.GetStringKeyText(stat.DisplayName, stat.DisplayNameRef))
			end
		end
	end
	if #addedSkills > 0 then
		table.sort(addedSkills)
		CombatLog.AddTextToPlayer(uuid, 0, string.format("Added Lich skills:<br>%s", StringHelpers.Join("<br>", addedSkills)))
	end
end

function LichSystem:RemoveSkills(uuid)
	for skill,level in pairs(self.Settings.Skills.LichForm) do
		if CharacterHasSkill(uuid, skill) == 1 then
			CharacterRemoveSkill(uuid, skill)
		end
	end
	for skill,level in pairs(self.Settings.Skills.Phylactery) do
		if CharacterHasSkill(uuid, skill) == 1 then
			CharacterRemoveSkill(uuid, skill)
		end
	end
	for tag,data in pairs(self.Settings.Skills.Racial) do
		if CharacterHasSkill(uuid, data.Replace) == 1 then
			CharacterRemoveSkill(uuid, data.Replace)
			if ObjectGetFlag(uuid, "LLLICH_LichRaceOriginallyUndead") == 0 then
				CharacterAddSkill(uuid, data.Original, 0)
			end
		end
	end
end

---@param player EsvCharacter
function LichSystem:CreateStaff(player)
	local uuid = player.MyGuid
	local itemId,item = GameHelpers.Item.CreateItemByStat("WPN_UNIQUE_LLLICH_LichStaff", {
		StatsLevel = player.Stats.Level,
		ItemType = "Unique",
		HasGeneratedStats = false,
		IsIdentified = true
	})
	if item then
		ItemToInventory(itemId, uuid, 1, 1, 1)
		return true
	end
	return false
end

---@param player EsvCharacter
function LichSystem:CreateSoulExtractor(player)
	local uuid = player.MyGuid
	local itemId,item = GameHelpers.Item.CreateItemByStat("WPN_UNIQUE_LLLICH_LichStaff", {
		StatsLevel = player.Stats.Level,
		ItemType = "Unique",
		HasGeneratedStats = false,
		IsIdentified = true
	})
	if item then
		ItemToInventory(itemId, uuid, 1, 1, 1)
		return true
	end
	return false
end

---@param player EsvCharacter
function LichSystem:CreateLich(player)
	local uuid = player.MyGuid
	local lich = self.Classes.LichData:New(player)
	self.Active[uuid] = lich
	SetTag(uuid, "LLLICH_Lich")
	NRD_PlayerSetBaseTalent(uuid, "Zombie", 1)
	CharacterAddCivilAbilityPoint(uuid, 0)
	self:AddSkills(uuid)
	self:SetRaceTag(player)
	if ObjectGetFlag(uuid, "LLLICH_Preset_GainedUniqueStaff") == 0 then
		if LichSystem:CreateStaff(player) then
			ObjectSetFlag(player.MyGuid, "LLLICH_Preset_GainedUniqueStaff", 0)
		end
	end
	if ObjectGetFlag(uuid, "LLLICH_Preset_GainedInitialSoulExtractor") == 0 then
		ObjectSetFlag(uuid, "LLLICH_Preset_GainedInitialSoulExtractor", 0)
		if not lich:HasPhylactery() then
			ObjectSetFlag(uuid, "QuestAdd_LLLICH_Main_CreatePhylactery", 0)
			ItemTemplateAddTo("PUZ_LLLICH_PhylacteryCreator_A_71cb1886-a2fc-4f3a-acd6-886485fa9bee", uuid, 1, 1)
		end
	end
end