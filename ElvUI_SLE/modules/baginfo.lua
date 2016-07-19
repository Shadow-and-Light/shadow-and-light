local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local BI = SLE:NewModule('BagInfo', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local B = E:GetModule('Bags')
local _G = _G
local byte = string.byte

local updateTimer
BI.containers = {}
BI.infoArray = {}
BI.equipmentMap = {}
local EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation

local function Utf8Sub(str, start, numChars)
	local currentIndex = start
	while numChars > 0 and currentIndex <= #str do
		local char = byte(str, currentIndex)

		if char > 240 then
			currentIndex = currentIndex + 4
		elseif char > 225 then
			currentIndex = currentIndex + 3
		elseif char > 192 then
			currentIndex = currentIndex + 2
		else
			currentIndex = currentIndex + 1
		end

		numChars = numChars -1
	end

	return str:sub(start, currentIndex - 1)
end

local function MapKey(bag, slot)
	return T.format("%d_%d", bag, slot)
end

local quickFormat = {
	[0] = function(font, map) font:SetText() end,
	[1] = function(font, map) font:SetFormattedText("|cffffffaa%s|r", Utf8Sub(map[1], 1, 4)) end,
	[2] = function(font, map) font:SetFormattedText("|cffffffaa%s %s|r", Utf8Sub(map[1], 1, 4), Utf8Sub(map[2], 1, 4)) end,
	[3] = function(font, map) font:SetFormattedText("|cffffffaa%s %s %s|r", Utf8Sub(map[1], 1, 4), Utf8Sub(map[2], 1, 4), Utf8Sub(map[3], 1, 4)) end,
}

local function BuildEquipmentMap(clear)
	-- clear mapped names
	for k, v in T.pairs(BI.equipmentMap) do
		T.twipe(v)
	end

	if clear then return end

	local name, player, bank, bags, slot, bag, key

	for i = 1, T.GetNumEquipmentSets() do
		name = T.GetEquipmentSetInfo(i)
		T.GetEquipmentSetLocations(name, BI.infoArray)
		for _, location in T.pairs(BI.infoArray) do
			if T.type(location) == "number" and (location < -1 or location > 1) then
				player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(location)
				if ((bank or bags) and slot and bag) then
					key = MapKey(bag, slot)
					BI.equipmentMap[key] = BI.equipmentMap[key] or {}
					T.tinsert(BI.equipmentMap[key], name)
				end
			end
		end
	end
end

local function UpdateContainerFrame(frame, bag, slot)
	if (not frame.equipmentinfo) then
		frame.equipmentinfo = frame:CreateFontString(nil, "OVERLAY")
		frame.equipmentinfo:FontTemplate(E.media.font, 12, "THINOUTLINE")
		frame.equipmentinfo:SetWordWrap(true)
		frame.equipmentinfo:SetJustifyH('CENTER')
		frame.equipmentinfo:SetJustifyV('MIDDLE')
	end

	if (frame.equipmentinfo) then
		frame.equipmentinfo:SetAllPoints(frame)

		local key = MapKey(bag, slot)
		if BI.equipmentMap[key] then	
			quickFormat[#BI.equipmentMap[key] < 4 and #BI.equipmentMap[key] or 3](frame.equipmentinfo, BI.equipmentMap[key])
		else
			quickFormat[0](frame.equipmentinfo, nil)
		end
	end
end

local function UpdateBagInformation(clear)
	updateTimer = nil

	BuildEquipmentMap(clear)
	for _, container in T.pairs(BI.containers) do
		for _, bagID in T.ipairs(container.BagIDs) do
			for slotID = 1, T.GetContainerNumSlots(bagID) do
				UpdateContainerFrame(container.Bags[bagID][slotID], bagID, slotID)
			end
		end
	end
end

local function DelayUpdateBagInformation(event)
	-- delay to make sure multiple bag events are consolidated to one update.
	if not updateTimer then
		updateTimer = BI:ScheduleTimer(UpdateBagInformation, .25)
	end
end

function BI:ToggleSettings()
	if updateTimer then
		self:CancelTimer(updateTimer)
	end

	if E.private.sle.equip.setoverlay then
		self:RegisterEvent("EQUIPMENT_SETS_CHANGED", DelayUpdateBagInformation)
		self:RegisterEvent("BAG_UPDATE", DelayUpdateBagInformation)
		UpdateBagInformation()
	else
		self:UnregisterEvent("EQUIPMENT_SETS_CHANGED")
		self:UnregisterEvent("BAG_UPDATE") 
		UpdateBagInformation(true)
	end
end

function BI:Initialize()
	if not SLE.initialized then return end
	if not E.private.bags.enable then return end

	T.tinsert(BI.containers, _G["ElvUI_ContainerFrame"])
	self:SecureHook(B, "OpenBank", function()
		self:Unhook(B, "OpenBank")
		T.tinsert(BI.containers, _G["ElvUI_BankContainerFrame"])
		BI:ToggleSettings()
	end)

	BI:ToggleSettings()
end

SLE:RegisterModule(BI:GetName())