local E, L, V, P, G = unpack(ElvUI);
local displayString = ""
local total, totalDurability, totalPerc = 0, 0, 0
local current, max, lastPanel, result
local invDurability = {}

local slots = {
	["SecondaryHandSlot"] = L['Offhand'],
	["MainHandSlot"] = L['Main Hand'],
	["FeetSlot"] = L['Feet'],
	["LegsSlot"] = L['Legs'],
	["HandsSlot"] = L['Hands'],
	["WristSlot"] = L['Wrist'],
	["WaistSlot"] = L['Waist'],
	["ChestSlot"] = L['Chest'],
	["ShoulderSlot"] = L['Shoulder'],
	["HeadSlot"] = L['Head'],
}

board[1].Status:SetScript("OnEvent", function( self, ...)

	lastPanel = self
	total = 0
	totalDurability = 0
	totalPerc = 0
	
	for index, value in pairs(slots) do
		local slot = GetInventorySlotInfo(index)
		current, max = GetInventoryItemDurability(slot)
		
		if current then
			totalDurability = totalDurability + current
			invDurability[value] = (current/max)*100
			totalPerc = totalPerc + (current/max)*100
			total = total + 1
		end
	end
	
	if total ~= 0 then
		result = totalPerc/total
	else
		result = 0
	end
	
	if total > 0 then
		board[1].Text:SetFormattedText(displayString, result)
	end
	
	self:SetMinMaxValues(0, 100)
	self:SetValue(result)
	
	if( result >= 75 ) then
		self:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
	elseif result < 75 and result > 40 then
		self:SetStatusBarColor(1, 180 / 255, 0, .8)
	else
		self:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
	end
end)

local function ValueColorUpdate(hex, r, g, b)
	displayString = string.join("", DURABILITY, ": ", hex, "%d%%|r")
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

board[1].Status:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
board[1].Status:RegisterEvent("MERCHANT_SHOW")
board[1].Status:RegisterEvent("PLAYER_ENTERING_WORLD")