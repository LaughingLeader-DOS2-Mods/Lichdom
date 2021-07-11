---@class PhylacteryTemplateData
local PhylacteryTemplateData = {
	Type = "PhylacteryTemplateData",
	Template = "",
	BrokenTemplate = ""
}

setmetatable(PhylacteryTemplateData, {
	---@param template string
	---@param broken string
	---@param params table|nil
	---@return PhylacteryTemplateData
	__call = function(template, broken, params)
		local tbl = {
			Template = template,
			BrokenTemplate = broken
		}
		if params then
			for k,v in pairs(params) do
				tbl[k] = v
			end
		end
		setmetatable(tbl, {__index = PhylacteryTemplateData})
		return tbl
	end
})

---@type table<string,PhylacteryTemplateData[]>
local Templates = {
	LLLICH_Phylactery_Amulet_A = {
		[0] = PhylacteryTemplateData("5d0c0bef-9071-4328-b72c-b58086b0f68d", "43577ebe-fec3-4f09-ae13-373aa10e123b"),
		[1] = PhylacteryTemplateData("38facf35-de7b-4eb0-baef-48f92c61166a", "2d720b82-a762-441f-9e51-7b8ada324239"),
		[2] = PhylacteryTemplateData("397a89d5-8fc9-4af2-a25a-dc9e998c223", "fa2727e9-10f9-44eb-a173-1cc94189981f"),
	},
	LLLICH_Phylactery_Ring_A = {
		[0] = PhylacteryTemplateData("cd0b735f-6c57-43b5-8d12-131b725dda48", "244e99ff-5fc9-4fcf-aa61-ff37959b90fd"),
		[1] = PhylacteryTemplateData("8f9126d5-ecc5-47b2-b9d8-f5d61f84f6fa", "Broken_2_594756d0-b438-4165-aab3-608ac8bf7df7"),
		[2] = PhylacteryTemplateData("845cdd4d-0ad9-49ac-84d5-b4dba325e13c", "719aeae2-9eba-4cfe-a51b-6808ac2d4279"),
	},
	LLLICH_Phylactery_Smallbox_A = {
		[0] = PhylacteryTemplateData("73c01ec2-7894-4d19-b12f-991650263332", "ea462acf-cfc8-4707-85e9-f647215b4893"),
		[1] = PhylacteryTemplateData("8d3d1223-48c5-481b-ac55-e407f71fb749", "a069aefa-a981-4f79-8ab7-1489ebfbc288"),
		[2] = PhylacteryTemplateData("2846990e-f2e4-48d8-8570-4854632cb557", "d2068826-c847-440b-ba41-cb822e8fcd00"),
	},
	LLLICH_Phylactery_Jar_A = {
		[0] = PhylacteryTemplateData("c6104ce9-f45e-4b4d-8740-7103782e51b5", "89484c10-cc66-4563-962e-c601ae129fc2"),
		[1] = PhylacteryTemplateData("200f1fc6-6ffc-4a2c-a737-fd3728cac456", "fc08fddf-33c3-44d0-b933-bc857075fee3"),
		[2] = PhylacteryTemplateData("e721ec07-9c56-48e1-8381-2fafa11770e8", "a1329644-95f3-4f8b-8946-c86ef4e159f1"),
	},
}

---@class PhylacteryData
local PhylacteryData = {
	Type = "PhylacteryData",
	---@type EsvCharacter
	Owner = nil,
	---@type PhylacteryTemplateData
	TemplateData = nil,
	---@type EsvItem
	Instance = nil,
	Settings = {
		DeathDamage = {
			[0] = -1,
			[1] = -2 -- Hardcore mode = Tactician
		}
	}
}

---@param item EsvItem
---@param owner EsvCharacter
---@param params table|nil
---@return PhylacteryData
function PhylacteryData:New(item,owner,params)
	local tbl = {
		Instance = item,
		Owner = owner
	}
	if params then
		for k,v in pairs(params) do
			tbl[k] = v
		end
	end
	setmetatable(tbl, {__index = PhylacteryData})
	return tbl
end

setmetatable(PhylacteryData, {
	__call = PhylacteryData.New
})

function PhylacteryData:Break()
	if self.Instance.RootTemplate.Id ~= self.BrokenTemplate then
		Transform(self.Instance.MyGuid, self.BrokenTemplate, 0, 0, 1)
		return true
	end
	return false
end

return PhylacteryData