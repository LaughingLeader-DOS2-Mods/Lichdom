---@type QuestData
local q = LeaderLib.Classes.QuestData
---@type QuestStateData
local qs = LeaderLib.Classes.QuestStateData

---@type table<string,QuestData>
local Quests = {
	Main = q:Create("LLLICH_Main_LichCreation")
}

local States = {
	CreatePhylactery = qs:Create("LLLICH_Main_CreatePhylactery"),
	PhylacteryCreated = qs:Create("LLLICH_Main_PhylacteryCreated")
}

Quests.Main:AddState(States)

function RegisterQuests()
	for quest,states in pairs(Quests) do
		for i,state in pairs(states) do
			Osi.DB_QuestDef_State(quest, state)
		end
	end
end

function StartPhylacteryQuest(uuid)
	ObjectSetFlag(uuid, "", 0)
end

LeaderLib.RegisterListener("Initialized", function(region)
	for i,db in pairs(Osi.DB_IsPlayer:Get(nil)) do
		local uuid = db[1]
		if IsTagged(uuid, "LLLICH_Lich") == 1 and not Quests.Main:HasQuest(uuid) then
			Quests.Main:Activate(uuid)
			local phylactery = GetVarObject(uuid, "LLLICH_Phylactery")
			if phylactery ~= nil then
				States.CreatePhylactery:Activate(uuid)
			else
				States.PhylacteryCreated:Activate(uuid)
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