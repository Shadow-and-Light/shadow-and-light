local MAJOR_VERSION = "LibKitUIConditions-1.0"
local MINOR_VERSION = 1

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end

local KitLib, oldLib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not KitLib then return end

local unpack, tinsert, pairs = unpack, tinsert, pairs
local strsub, strlen = strsub, strlen

KitLib.registeredConditions = {};

function KitLib:RegisterCondition(tag, numArguments, validationFunc)
	if (self.registeredConditions[tag]) then return end
	self.registeredConditions[tag] = { numArguments = numArguments, validationFunc = validationFunc };
	self.registeredConditions[tag].matchStr = self:BuildConditionMatch(tag);
	self.registeredConditions[tag].negateMatchStr = strsub(self.registeredConditions[tag].matchStr,1,2) .. "no" .. strsub(self.registeredConditions[tag].matchStr,3,strlen(self.registeredConditions[tag].matchStr) - 2);
end

function KitLib:UnregisterCondition(tag)
	self.registeredConditions[tag] = nil;
end

function KitLib:BuildConditionMatch(tag)
	local info = self.registeredConditions[tag];
	if (not info) then return end

	local matchStr = "%["..tag;
	if (info.numArguments > 0) then
		for i = 1, info.numArguments do
			local sep = ":";
			if (i > 1) then
				sep = "/";
			end
			matchStr = matchStr .. sep .. "([^/%]]+)";
		end
	end
	matchStr = matchStr .. "%]";
	return matchStr;
end

function KitLib:EvaluateConditionString(conditionString)
	for k, v in pairs(self.registeredConditions) do
		if (conditionString:match(v.matchStr)) then
			local args = { conditionString:match(v.matchStr) };
			if (not v.validationFunc(unpack(args))) then
				return false;
			end
		elseif (conditionString:match(v.negateMatchStr)) then
			local args = { conditionString:match(v.negateMatchStr) };
			if (v.validationFunc(unpack(args))) then
				return false;
			end
		end
	end

	return true;
end

function KitLib:GetTagsFromConditionString(conditionString)
	local tagsFound = {};
	for k, v in pairs(self.registeredConditions) do
		if (conditionString:match(v.matchStr)) then
			tinsert(tagsFound, k);
		end
	end
	return tagsFound;
end

-- function KTValidate(arg)
	-- if (tonumber(arg) == 77) then
		-- return true;
	-- else
		-- return false;
	-- end
-- end

-- function KitTest()
	-- KitLib:RegisterCondition("test", 1, KTValidate);
	-- assert(KitLib:EvaluateConditionString("[test:77]"));
	-- assert(not KitLib:EvaluateConditionString("[notest:77]"));
	-- assert(not KitLib:EvaluateConditionString("[test:82]"));
	-- assert(KitLib:EvaluateConditionString("[notest:82]"));
	-- print("All tests passed");
	-- KitLib:UnregisterCondition("test");
-- end