local E, L, V, P, G, _ = unpack(ElvUI);
local SLE = E:GetModule('SLE')
local BG = E:GetModule('SLE_BackGrounds')
local DTP = E:GetModule('SLE_DTPanels')
local CH = E:GetModule("Chat")
local UB = E:GetModule('SLE_UIButtons')
local RM = E:GetModule('SLE_RaidMarks')
local RF = E:GetModule('SLE_RaidFlares')
local F = E:GetModule('SLE_Farm')
local LT = E:GetModule('SLE_Loot')
local UF = E:GetModule('UnitFrames')
local M = E:GetModule('SLE_Media')
local I = E:GetModule('SLE_InstDif')

local GetContainerNumSlots, GetContainerItemID = GetContainerNumSlots, GetContainerItemID

function SLE:BagSearch(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

function SLE:ValueTable(table, item)
	for i, _ in pairs(table) do
		if i == item then return true end
	end

	return false
end

function SLE:SimpleTable(table, item)
	for i = 1, #table do
		if table[i] == item then  
			return true 
		end
	end

	return false
end

function SLE:Print(msg)
	print(E["media"].hexvaluecolor..'S&L:|r', msg)
end

local function UpdateAll()
	BG:UpdateFrames()
	BG:RegisterHide()
	DTP:Update()
	DTP:DashboardShow()
	DTP:DashWidth()
	if E.private.unitframe.enable then
		UF:Update_CombatIndicator()
	end
	LT:LootShow()
	LT:Update()
	UB:UpdateAll()
	RM:Update()
	RF:Update()
	F:UpdateLayout()
	CH:GMIconUpdate()
	M:TextWidth()
	I:UpdateFrame()

	collectgarbage('collect');
end

hooksecurefunc(E, "UpdateAll", UpdateAll)