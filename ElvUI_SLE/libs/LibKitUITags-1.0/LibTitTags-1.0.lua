local MAJOR_VERSION = "LibKitUITags-1.0"
local MINOR_VERSION = 1

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end

local KitLib, oldLib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not KitLib then return end

local pairs, ipairs = pairs, ipairs

KitLib.registeredTags = {};
KitLib.registeredEvents = {};
KitLib.registeredTagStrings = {};

function KitLib:RegisterTag(tag, updateFunc, ...)
	local events = { ... };
	KitLib.registeredTags[tag] = { updateFunc = updateFunc, events = events };
	for i, event in ipairs(events) do
		if (not KitLib.registeredEvents[event]) then
			KitLib.driverFrame:RegisterEvent(event);
			KitLib.registeredEvents[event] = 0;
		end
		KitLib.registeredEvents[event] = KitLib.registeredEvents[event] + 1;
	end
end

function KitLib:UnregisterTag(tag)
	if (not KitLib.registeredTags[tag]) then return end
	local events = KitLib.registeredTags[tag].events;
	for i, event in ipairs(events) do
		KitLib.registeredEvents[event] = KitLib.registeredEvents[event] - 1;
		if (KitLib.registeredEvents[event] == 0) then
			KitLib.driverFrame:UnregisterEvent(event);
			KitLib.registeredEvents[event] = nil;
		end
	end
	KitLib.registeredTags[tag] = nil;
end

function KitLib:RegisterFontString(key, fs)
	if (not KitLib.registeredTagStrings[key]) then
		KitLib.registeredTagStrings[key] = {};
	end
	KitLib.registeredTagStrings[key].fs = fs;
end

function KitLib:UnregisterFontString(key)
	KitLib.registeredTagStrings[key] = nil;
end

function KitLib:Tag(key, tagStr)
	if (not KitLib.registeredTagStrings[key]) then return end
	KitLib.registeredTagStrings[key].backingText = tagStr;
	KitLib:UpdateTagStrings();
end

KitLib.driverFrame = CreateFrame("Frame");
KitLib.driverFrame:SetScript("OnEvent", function(self, event, ...)
	KitLib:UpdateTagStrings();
end)

local CurrentFS;
KitLib.tagDirector = {};
setmetatable(KitLib.tagDirector, {
	__index = function(table, key)
		if (KitLib.registeredTags[key]) then
			return KitLib.registeredTags[key].updateFunc(CurrentFS);
		end
		return nil;
	end,
});

function KitLib:UpdateTagStrings(event)
	for k, v in pairs(KitLib.registeredTagStrings) do
		CurrentFS = v.fs;
		v.fs:SetText(v.backingText:gsub('%[([^%]]+)%]', KitLib.tagDirector));
	end
end