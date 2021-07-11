---@type QuestData
local q = Classes.QuestData
---@type QuestStateData
local qs = Classes.QuestStateData

---@type table<string,QuestData>
local Quests = {
	Main = q:Create("LLLICH_Main_LichCreation")
}

local MainStates = {
	CreatePhylactery = qs:Create("LLLICH_Main_CreatePhylactery"),
	PhylacteryCreated = qs:Create("LLLICH_Main_PhylacteryCreated"),
	UpgradePhylactery1 = qs:Create("LLLICH_Main_PhylacteryUpgrading1"),
}

Quests.Main:AddState(MainStates)

function RegisterQuests()
	for questName,data in pairs(Quests) do
		data:RegisterDatabases()
	end
end

function StartPhylacteryQuest(uuid)
	Quests.Main:Activate(uuid)
end

RegisterListener("Initialized", function(region)
	for i,db in pairs(Osi.DB_IsPlayer:Get(nil)) do
		local uuid = db[1]
		if IsTagged(uuid, "LLLICH_Lich") == 1 then
			if not Quests.Main:HasQuest(uuid) then
				Quests.Main:Activate(uuid)
			end
			local phylactery = GetVarObject(uuid, "LLLICH_Phylactery")
			if StringHelpers.IsNullOrEmpty(phylactery) then
				MainStates.CreatePhylactery:Activate(uuid)
			else
				MainStates.CreatePhylactery:Activate(uuid)
				MainStates.PhylacteryCreated:Activate(uuid)
				MainStates.UpgradePhylactery1:Activate(uuid)
			end
		end
	end
end)

Ext.RegisterOsirisListener("RegionStarted", 1, "after", function(region)
	if IsGameLevel(region) == 1 then
		for id,quest in pairs(Quests) do
			quest:RegisterDatabases()
		end
	end
end)