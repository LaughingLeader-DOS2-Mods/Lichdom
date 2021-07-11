Ext.Require("Shared/_Init.lua")

local function VarsLoaded()

end

---@type LichdomPersistentVars
LichdomPersistentVars = GameHelpers.PersistentVars.Initialize(_G, DefaultLichdomPersistentVars, VarsLoaded)

Ext.Require("Server/_Init.lua")

-- Ext.RegisterListener("ModuleLoading", function()

-- end)
-- Ext.RegisterListener("SessionLoading", function()

-- end)

Ext.RegisterConsoleCommand("hotbartest", function(cmd, ...)
	Ext.BroadcastMessage("LLLICH_Debug_HotbarTest", "", nil)
end)

function SyncClientData(id)
	---@type LichdomPersistentVars
	local data = Common.CopyTable(DefaultLichdomPersistentVars, true)
	for uuid,v in pairs(LichdomPersistentVars.PhylacteryType) do
		local netid = GameHelpers.GetNetID(uuid)
		if netid then
			data.PhylacteryType[netid] = v
		end
	end
	for uuid,v in pairs(LichdomPersistentVars.SoulReaper) do
		local netid = GameHelpers.GetNetID(uuid)
		if netid then
			data.SoulReaper[netid] = v
		end
	end
	for uuid,v in pairs(LichdomPersistentVars.TwinSkullsEnergy) do
		local netid = GameHelpers.GetNetID(uuid)
		if netid then
			data.TwinSkullsEnergy[netid] = v
		end
	end
	
	if id == nil then
		Ext.BroadcastMessage("LLLICH_SyncPersistentVars", Ext.JsonStringify(data), nil)
	else
		local t = type(id)
		if t == "string" then
			Ext.PostMessageToClient(id, "LLLICH_SyncPersistentVars", Ext.JsonStringify(data))
		elseif t == "number" then
			Ext.PostMessageToUser(id, "LLLICH_SyncPersistentVars", Ext.JsonStringify(data))
		end
	end
	if Ext.IsDeveloperMode() then
		Ext.Print("[Lichdom] PersistentVars", Ext.JsonStringify(data))
	end
end

---@param id integer
---@param profile string
---@param uuid string
---@param isHost boolean
RegisterListener("SyncData", function(id, profile, uuid, isHost)
	SyncClientData(id)
end)