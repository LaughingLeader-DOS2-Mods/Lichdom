---@type MessageData
local MessageData = LeaderLib.Classes["MessageData"]
ClientData = {}

local function StoreClientData(channel, data)
	---@type MessageData
	local messageData = MessageData:CreateFromString(data)
	if messageData ~= nil then
		if ClientData[messageData.ID] == nil then
			ClientData[messageData.ID] = {}
		end
		if messageData.Params ~= nil and messageData.Params.UUID ~= nil then
			ClientData[messageData.ID][messageData.Params.UUID] = messageData
		end
	end
end

Ext.RegisterNetListener("LLLICH_StoreClientData", StoreClientData)