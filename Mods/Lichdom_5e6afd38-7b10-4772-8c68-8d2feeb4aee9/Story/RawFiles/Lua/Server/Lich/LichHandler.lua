---@class LichSystem
LichSystem = {
	---@type table<UUID,LichData>
	Active = {},
	Classes = {
		---@type LichData
		LichData = Ext.Require("Server/Lich/Data/LichData.lua"),
		---@type PhylacteryData
		PhylacteryData = Ext.Require("Server/Lich/Data/PhylacteryData.lua")
	},
	---@type PhylacteryData[]
	OrphanedPhylacteries = {},
	Settings = {
		Skills = {
			LichForm = {
				Target_LLLICH_ChillTouch = 0,
				Shout_LLLICH_ChillForm = 0,
				Target_LLLICH_DrainSoul = 0,
				Target_LLLICH_DrainSoul = 0,
				Shout_LLLICH_SoulReaper = 1,
				Target_LLLICH_DominateUndead = 2,
			},
			Phylactery = {
				Shout_LLLICH_Recall = 0
			},
			Racial = {
				DWARF = {Original="Target_PetrifyingTouch", Replace="Target_LLLICH_ParalyzingTouch"},
				HUMAN = {Original="Shout_InspireStart", Replace="Shout_LLLICH_DreadShout"},
				ELF = {Original="Shout_FleshSacrifice", Replace="Target_LLLICH_FleshSacrifice"},
				LIZARD = {Original="Cone_Flamebreath", Replace="Cone_LLLICH_Chillbreath"},
			}
		},
		TagSwap = {
			DWARF = "UNDEAD_DWARF",
			HUMAN = "UNDEAD_HUMAN",
			ELF = "UNDEAD_ELF",
			LIZARD = "UNDEAD_LIZARD",
		}
	}
}

local self = LichSystem

---@private
function LichSystem.Init(region)
	for player in GameHelpers.Character.GetPlayers() do
		if player:HasTag("LLLICH_Lich") then
			self.Active[player.MyGuid] = self.Classes.LichData:New(player)
		end
	end
	for lichId,itemId in pairs(LichdomPersistentVars.ActivePhylacteries) do
		local item,owner = Ext.GetItem(itemId),Ext.GetCharacter(lichId)
		if item and owner then
			local phylactery = self.Classes.PhylacteryData:New(item, owner)
			local lich = self.Active[lichId]
			if lich then
				lich.Phylactery = phylactery
			else
				self.OrphanedPhylacteries[#self.OrphanedPhylacteries+1] = phylactery
			end
		end
	end
	for uuid,lich in pairs(self.Active) do
		if lich.Phylactery == nil then
			fprint(LOGLEVEL.ERROR, "[Lichdom] Lich (%s)[%s] has no phylactery! Help!", lich.Instance.DisplayName, uuid)
		end
	end
end

RegisterListener("Initialized", LichSystem.Init)