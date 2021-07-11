---@type LichdomPersistentVars
ClientData = Common.CopyTable(DefaultLichdomPersistentVars, true)

Ext.RegisterNetListener("LLLICH_SyncPersistentVars", function(channel, datastr)
	local data = Common.JsonParse(datastr)
	if data ~= nil then
		ClientData = data
	end
end)