local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DT = E:GetModule('DataTexts')
local HEADSLOT, NECKSLOT, SHOULDERSLOT, BACKSLOT, CHESTSLOT, WRISTSLOT, HANDSSLOT, WAISTSLOT, LEGSSLOT, FEETSLOT, FINGER0SLOT_UNIQUE, FINGER1SLOT_UNIQUE, TRINKET0SLOT_UNIQUE, TRINKET1SLOT_UNIQUE, MAINHANDSLOT, SECONDARYHANDSLOT = HEADSLOT, NECKSLOT, SHOULDERSLOT, BACKSLOT, CHESTSLOT, WRISTSLOT, HANDSSLOT, WAISTSLOT, LEGSSLOT, FEETSLOT, FINGER0SLOT_UNIQUE, FINGER1SLOT_UNIQUE, TRINKET0SLOT_UNIQUE, TRINKET1SLOT_UNIQUE, MAINHANDSLOT, SECONDARYHANDSLOT
local displayString = ''
local lastPanel
local ITEM_LEVEL_ABBR = ITEM_LEVEL_ABBR
local GMSURVEYRATING3 = GMSURVEYRATING3
local TOTAL = TOTAL
local GetEquippedArtifactRelicInfo = C_ArtifactUI.GetEquippedArtifactRelicInfo
local GetItemLevelIncreaseProvidedByRelic = C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic

local Scan = CreateFrame('GameTooltip', 'SLE_IlvlDT_ScanTT', nil, 'GameTooltipTemplate')
Scan:SetOwner(UIParent, 'ANCHOR_NONE')
local CurrentLineText
local ItemLevelKey = ITEM_LEVEL:gsub('%%d', '(.+)')
local ItemLevelKey_Alt = ITEM_LEVEL_ALT:gsub('%%d', '.+'):gsub('%(.+%)', '%%((.+)%%)')

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
	self.avgItemLevel, self.avgEquipItemLevel = T.GetAverageItemLevel()
	self.text:SetFormattedText(displayString, ITEM_LEVEL_ABBR, T.floor(self.avgEquipItemLevel), T.floor(self.avgItemLevel))
end

local function ClearTooltip(Tooltip)
	local TooltipName = Tooltip:GetName()

	Tooltip:ClearLines()
	for i = 1, 10 do
		_G[TooltipName..'Texture'..i]:SetTexture(nil)
		_G[TooltipName..'Texture'..i]:ClearAllPoints()
		_G[TooltipName..'Texture'..i]:Point('TOPLEFT', Tooltip)
	end
end

local function GetItemLevel()
	local itemLevel
	for i = 1, Scan:NumLines() do
		CurrentLineText = _G["SLE_IlvlDT_ScanTTTextLeft"..i]:GetText()
		if CurrentLineText:find(ItemLevelKey_Alt) then
			itemLevel = T.tonumber(CurrentLineText:match(ItemLevelKey_Alt))
		elseif CurrentLineText:find(ItemLevelKey) then
			itemLevel = T.tonumber(CurrentLineText:match(ItemLevelKey))
		end
	end
	return itemLevel
end

local function OnEnter(self)
	T.twipe(tooltipOrder)
	local avgItemLevel, avgEquipItemLevel = self.avgItemLevel, self.avgEquipItemLevel
	DT:SetupTooltip(self)
	DT.tooltip:AddDoubleLine(TOTAL, T.floor(avgItemLevel), 1, 1, 1, 0, 1, 0)
	DT.tooltip:AddDoubleLine(GMSURVEYRATING3, T.floor(avgEquipItemLevel), 1, 1, 1, 0, 1, 0)
	DT.tooltip:AddLine(" ")
	for i in T.pairs(slots) do
		ClearTooltip(Scan)
		Scan:SetInventoryItem('player', i)
		local itemLevel = GetItemLevel()
		if itemLevel and avgEquipItemLevel then
			local color = levelColors[(itemLevel < avgEquipItemLevel - 10 and 0 or (itemLevel > avgEquipItemLevel + 10 and 1 or (2)))]
			tooltipOrder[slots[i][3]] = {slots[i][2], itemLevel, 1, 1, 1, color[1], color[2], color[3]}
		end
	end
	for i in T.pairs(tooltipOrder) do
		if tooltipOrder[i] then DT.tooltip:AddDoubleLine(T.unpack(tooltipOrder[i])) end
	end
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = T.join("", "|cffffffff%s:|r", " ", hex, "%d / %d|r")
	if lastPanel ~= nil then OnEvent(lastPanel) end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("S&L Item Level", {"PLAYER_ENTERING_WORLD", "PLAYER_EQUIPMENT_CHANGED", "UNIT_INVENTORY_CHANGED"}, OnEvent, nil, nil, OnEnter)