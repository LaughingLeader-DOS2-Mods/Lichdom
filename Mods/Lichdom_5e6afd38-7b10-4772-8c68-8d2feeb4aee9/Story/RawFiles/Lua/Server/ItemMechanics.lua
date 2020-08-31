local MagicSchools = {
	Source = true,
	Fire = true,
	Water = true,
	Air = true,
	Earth = true,
	Death = true,
	Summoning = true,
	Polymorph = true,
}

function IncreaseTwinSkullsEnergy(uuid, skillid)
	---@type StatEntrySkillData
	local skill = Ext.GetStat(skillid)
	if skill["Magic Cost"] > 0 or (skill.ActionPoints > 0 and MagicSchools[skill.Ability] == true) then
		local currentEnergy = 0
		if PersistentVars.TwinSkullsEnergy[uuid] ~= nil then
			currentEnergy = PersistentVars.TwinSkullsEnergy[uuid] or 0
		end
		-- local db = Osi.DB_LLLICH_Skills_Temp_TwinSkullsEnergy:Get(nil, nil, nil)
		-- if db ~= nil then
		-- 	for i,v in pairs(db) do
		-- 		if GetUUID(v[1]) == uuid then
		-- 			currentEnergy = v[3]
		-- 		end
		-- 	end
		-- end
		local max = Ext.ExtraData.LLLICH_TwinSkulls_MaxEnergy or 10
		if currentEnergy < max then
			currentEnergy = currentEnergy + 1
			PersistentVars.TwinSkullsEnergy[uuid] = currentEnergy
			SyncClientData(uuid)
			--Osi.LLLICH_TwinSkulls_StoreEnergy(uuid, math.min(currentEnergy + 1, max))
			if HasActiveStatus(uuid, "LLLICH_TWINSKULLS_ENERGY") == 0 then
				ApplyStatus(uuid, "LLLICH_TWINSKULLS_ENERGY", -1.0, 0, uuid)
			end
		end
		local hasTag = IsTagged(uuid, "LLLICH_TwinSkulls_EnergyMax") == 0
		if currentEnergy >= max and hasTag then
			SetTag(uuid, "LLLICH_TwinSkulls_EnergyMax")
		elseif hasTag then
			ClearTag(uuid, "LLLICH_TwinSkulls_EnergyMax")
		end
	end
end

function ClearTwinSkullsEnergy(uuid, recursive)
	if uuid ~= nil then
		PersistentVars.TwinSkullsEnergy[uuid] = 0
		SyncClientData(uuid)
		if HasActiveStatus(uuid, "LLLICH_TWINSKULLS_ENERGY") == 1 then
			RemoveStatus(uuid, "LLLICH_TWINSKULLS_ENERGY")
		end
		ClearTag(uuid, "LLLICH_TwinSkulls_EnergyMax")
	elseif recursive ~= true then
		for uuid,amount in pairs(PersistentVars.TwinSkullsEnergy) do
			ClearTwinSkullsEnergy(uuid, true)
		end
	end
end