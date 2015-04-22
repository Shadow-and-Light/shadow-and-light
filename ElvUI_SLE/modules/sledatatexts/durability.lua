local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

local join = string.join

local displayString = ""
local tooltipString = "%d%%"
local totalDurability = 0
local current, max, lastPanel
local invDurability = {}
local slots = {
	["SecondaryHandSlot"] = L["Offhand"],
	["MainHandSlot"] = L["Main Hand"],
	["FeetSlot"] = L["Feet"],
	["LegsSlot"] = L["Legs"],
	["HandsSlot"] = L["Hands"],
	["WristSlot"] = L["Wrist"],
	["WaistSlot"] = L["Waist"],
	["ChestSlot"] = L["Chest"],
	["ShoulderSlot"] = L["Shoulder"],
	["HeadSlot"] = L["Head"],
}

local function OnEvent(self, event, ...)
    lastPanel = self
    totalDurability = 100
    for index, value in pairs(slots) do
        local slot = GetInventorySlotInfo(index)
        current, max = GetInventoryItemDurability(slot)
        if current then
            invDurability[value] = (current/max)*100
            if ((current/max) * 100) < totalDurability then
                totalDurability = (current/max) * 100
            end
        end
    end
    if totalDurability <= E.db.sle.dt.durability.threshold then
        E:Flash(self, 0.53, true)
    else
        E:StopFlash(self)
    end
	if E.db.sle.dt.durability.gradient then
		local r,g,b = E:ColorGradient(totalDurability/100, .9,.2,.2, .9,.9,.2, .2,.9,.2)
		local hex = E:RGBToHex(r,g,b)
		self.text:SetFormattedText("%s: %s%d%%|r", DURABILITY, hex, totalDurability)
	else
		self.text:SetFormattedText(displayString, totalDurability)
	end
end

local function Click()
	ToggleCharacter("PaperDollFrame")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for slot, durability in pairs(invDurability) do
		DT.tooltip:AddDoubleLine(slot, format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, 0, 0, 1, 1, 0, 0, 1, 0))
	end

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", DURABILITY, ": ", hex, "%d%%|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel, 'ELVUI_COLOR_UPDATE')
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('Durability', {'PLAYER_ENTERING_WORLD', "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW"}, OnEvent, nil, Click, OnEnter)

