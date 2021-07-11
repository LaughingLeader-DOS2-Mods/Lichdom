---@class LichSaveData
---@field PhylacteryType string
---@field SoulLevel integer

local LichSaveData = {
	PhylacteryType = "Ring",
	SoulLevel = 0
}

---@class LichData
---@field Instance EsvCharacter
---@field Phylactery PhylacteryData
local LichData = {
	Type = "LichData"
}

---@param player EsvCharacter
---@param params LichData
---@return LichData
function LichData:New(player, params)
	local tbl = {
		Instance = player,
		Phylactery = nil
	}
	if params then
		for k,v in pairs(params) do
			tbl[k] = v
		end
	end
	setmetatable(tbl, {__index = LichData})
	return tbl
end

setmetatable(LichData, {
	__call = LichData.New
})

function LichData:HasPhylactery()
	return self.Phylactery ~= nil and self.Phylactery.Instance ~= nil
end

return LichData