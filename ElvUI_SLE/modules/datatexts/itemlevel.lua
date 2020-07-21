local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

local GetEquippedArtifactRelicInfo = C_ArtifactUI.GetEquippedArtifactRelicInfo
local GetItemLevelIncreaseProvidedByRelic = C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic
local GetAverageItemLevel = GetAverageItemLevel
local HEADSLOT, NECKSLOT, SHOULDERSLOT, BACKSLOT, CHESTSLOT, WRISTSLOT, HANDSSLOT, WAISTSLOT, LEGSSLOT, FEETSLOT, FINGER0SLOT_UNIQUE, FINGER1SLOT_UNIQUE, TRINKET0SLOT_UNIQUE, TRINKET1SLOT_UNIQUE, MAINHANDSLOT, SECONDARYHANDSLOT = HEADSLOT, NECKSLOT, SHOULDERSLOT, BACKSLOT, CHESTSLOT, WRISTSLOT, HANDSSLOT, WAISTSLOT, LEGSSLOT, FEETSLOT, FINGER0SLOT_UNIQUE, FINGER1SLOT_UNIQUE, TRINKET0SLOT_UNIQUE, TRINKET1SLOT_UNIQUE, MAINHANDSLOT, SECONDARYHANDSLOT
local ITEM_LEVEL_ABBR = ITEM_LEVEL_ABBR
local GMSURVEYRATING3 = GMSURVEYRATING3
local TOTAL = TOTAL

local displayString = ''
local lastPanel

local slots = {
	[1] = { "HeadSlot", HEADSLOT, 1},
	[2] = { "NeckSlot", NECKSLOT, 2},
	[3] = { "ShoulderSlot", SHOULDERSLOT, 3},
	[5] = { "ChestSlot", CHESTSLOT, 5},
	[6] = { "WaistSlot", WAISTSLOT, 8},
	[7] = { "LegsSlot", LEGSSLOT, 9},
	[8] = { "FeetSlot", FEETSLOT, 10},
	[9] = { "WristSlot", WRISTSLOT, 6},
	[10] = { "HandsSlot", HANDSSLOT, 7},
	[11] = { "Finger0Slot", FINGER0SLOT_UNIQUE, 11},
	[12] = { "Finger1Slot", FINGER1SLOT_UNIQUE, 12},
	[13] = { "Trinket0Slot", TRINKET0SLOT_UNIQUE, 13},
	[14] = { "Trinket1Slot", TRINKET1SLOT_UNIQUE, 14},
	[15] = { "BackSlot", BACKSLOT, 4},
	[16] = { "MainHandSlot", MAINHANDSLOT, 15},
	[17] = { "SecondaryHandSlot", SECONDARYHANDSLOT, 16},
}

local tooltipOrder = {}

local levelColors = {
	[0] = { 1, 0, 0 },
	[1] = { 0, 1, 0 },
	[2] = { 1, 1, .5 },
}

local function OnEvent(self)
	self.avgItemLevel, self.avgEquipItemLevel = GetAverageItemLevel()
	self.text:SetFormattedText(displayString, ITEM_LEVEL_ABBR, floor(self.avgEquipItemLevel), floor(self.avgItemLevel))
	lastPanel = self
end

local ArtifactsIlvl = {}
local function OnEnter(self)
	DT.tooltip:ClearLines()
	local avgItemLevel, avgEquipItemLevel = self.avgItemLevel, self.avgEquipItemLevel
	wipe(tooltipOrder)
	wipe(ArtifactsIlvl)
	DT.tooltip:AddDoubleLine(TOTAL, floor(avgItemLevel), 1, 1, 1, 0, 1, 0)
	DT.tooltip:AddDoubleLine(GMSURVEYRATING3, floor(avgEquipItemLevel), 1, 1, 1, 0, 1, 0)
	DT.tooltip:AddLine(" ")
	for i in pairs(slots) do
		local ItemLink = GetInventoryItemLink('player', i)
		if ItemLink then
			local ItemRarity = select(3, GetItemInfo(ItemLink))
			local isArtifact = (ItemRarity == 6)
			local itemLevel = GetDetailedItemLevelInfo(ItemLink)
			if itemLevel and avgEquipItemLevel and not isArtifact then
				local color = levelColors[(itemLevel < avgEquipItemLevel - 10 and 0 or (itemLevel > avgEquipItemLevel + 10 and 1 or (2)))]
				tooltipOrder[slots[i][3]] = {slots[i][2], itemLevel, 1, 1, 1, color[1], color[2], color[3]}
			elseif itemLevel and avgEquipItemLevel and isArtifact then
				ArtifactsIlvl[slots[i][3]] = {slots[i][3], slots[i][2], itemLevel}
			end
		end
	end
	if ArtifactsIlvl[15] then
		if ArtifactsIlvl[16] then
			if ArtifactsIlvl[15][3] > ArtifactsIlvl[16][3] then
				ArtifactsIlvl[16][3] = ArtifactsIlvl[15][3]
			elseif ArtifactsIlvl[15][3] < ArtifactsIlvl[16][3] then
				ArtifactsIlvl[15][3] = ArtifactsIlvl[16][3]
			end
		end
		for slot, data in pairs(ArtifactsIlvl) do
			local itemLevel = data[3]
			local color = levelColors[(itemLevel < avgEquipItemLevel - 10 and 0 or (itemLevel > avgEquipItemLevel + 10 and 1 or (2)))]
			tooltipOrder[data[1]] = {data[2], data[3], 1, 1, 1, color[1], color[2], color[3]}
		end
	end
	for i in pairs(tooltipOrder) do
		if tooltipOrder[i] then DT.tooltip:AddDoubleLine(unpack(tooltipOrder[i])) end
	end
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = strjoin("", "%s:", " ", hex, "%d / %d|r")
	if lastPanel ~= nil then OnEvent(lastPanel) end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("S&L Item Level", 'S&L', {"LOADING_SCREEN_DISABLED", "PLAYER_EQUIPMENT_CHANGED", "UNIT_INVENTORY_CHANGED"}, OnEvent, nil, nil, OnEnter)
