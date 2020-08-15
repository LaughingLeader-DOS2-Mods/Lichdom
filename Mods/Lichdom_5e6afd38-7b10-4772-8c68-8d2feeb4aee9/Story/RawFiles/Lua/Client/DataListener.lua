---@type MessageData
local msg = LeaderLib.Classes["MessageData"]

ClientData = {}

Ext.RegisterNetListener("LLLICH_SyncPersistentVars", function(channel, datastr)
	local data = Ext.JsonParse(datastr)
	if data ~= nil then
		ClientData = data
		print("ClientData", Ext.JsonStringify(ClientData))
	end
end)