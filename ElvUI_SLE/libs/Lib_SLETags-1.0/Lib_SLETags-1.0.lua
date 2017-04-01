local MAJOR, MINOR = "Lib_SLETags-1.0", 1
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
--GLOBALS: CreateFrame
if not lib then return end

local _G = _G
local tinsert, ipairs = tinsert, ipairs

lib.TagsTable = {}

function lib:ComplexTags_Process(module, msg)
	local pattern = "%[(.-)%]([^;]+)"
	local data = {}
	local split_msg = { (";"):split(msg) }

	for i, v in ipairs(split_msg) do
		local split = split_msg[i]
		local condition, option = split:match(pattern)
		if (condition and option) then
			local cnd_table = { (","):split(condition) }
			local parsed_cmds = {};
			for j = 1, #cnd_table do
				local cnd = cnd_table[j];
				if cnd then
					local command, argument = (":"):split(cnd)
					tinsert(parsed_cmds, { cmd = command:match("^%s*(.+)%s*$"), arg = argument })
				end
			end
			tinsert(data, { option = option, cmds = parsed_cmds, module = module })
		end
	end

	return data
end

function lib:SimpleTags_Process(module, msg)
	local pattern = "%[(.-)%]%([^;]+)"
	local data = {}
	local split_msg = { (";"):split(msg) }

	for i, v in ipairs(split_msg) do
		local split = split_msg[i]
		
	end
end

function lib:ComplexTags_ConditionsCheck(data)
	for index,tagInfo in ipairs(data) do 
		local module = tagInfo.module
		local ok = true
		for conditionIndex,conditionInfo in ipairs(tagInfo.cmds) do
			local func = conditionInfo["cmd"]
			local arg = conditionInfo["arg"]
			local result = lib.TagsTable[module][func](arg)
			if not result then 
				ok = false
				break 
			end
		end
		if ok then 
			return tagInfo.option
		end
	end
end