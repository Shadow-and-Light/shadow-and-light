local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Gar = SLE:NewModule("Garrison", 'AceEvent-3.0')
local _G = _G
local B = LibStub("LibBabble-SubZone-3.0")
local BL = B:GetLookupTable()
local garrisonzones = { BL["Salvage Yard"], BL["Frostwall Mine"], BL["Lunarfall Excavation"]}
local Tools = SLE:GetModule("Toolbars")
local buildID = {
	[8] = "War",
	[9] = "War",
	[10] = "War",
	[111] = "Trade",
	[144] = "Trade",
	[145] = "Trade",
	[205] = "Ship",
	[206] = "Ship",
	[207] = "Ship",
}
local C_Garrison = C_Garrison

local GarTools = {
	[1] = {
		114116, -- Bag of Salvaged Goods
		114119, -- Crate of Salvage
		114120, -- Big Crate of Salvage
		139593, -- New Small sack
		140590, -- New big Crate
		-- 114120, -- Big Crate of Salvage
		118903, -- Minepick
		118897, -- Coffee
	},
}

function Gar:SHIPMENT_CRAFTER_INFO(event, success, shipmentCount, maxShipments, ownedShipments, plotID)
	if not _G["GarrisonCapacitiveDisplayFrame"] then return end --Just in case
	if not C_Garrison.IsPlayerInGarrison(2) and not C_Garrison.IsOnShipyardMap() then return end
	local n = _G["GarrisonCapacitiveDisplayFrame"].available or 0
	if Gar.clicked or n == 0 or not Gar.db.autoOrder.enable then return end
	Gar.clicked = true
	local ID = C_Garrison.GetOwnedBuildingInfo(plotID)
	local nope = buildID[ID]
	if nope then
		if Gar.db.autoOrder["auto"..nope] then
			_G["GarrisonCapacitiveDisplayFrame"].CreateAllWorkOrdersButton:Click()
		end
	else
		_G["GarrisonCapacitiveDisplayFrame"].CreateAllWorkOrdersButton:Click()
	end
end

function Gar:SHIPMENT_CRAFTER_CLOSED()
	Gar.clicked = false
end

local function CanGarrisonBar()
	if not E.db.sle.legacy.garrison.toolbar.enable then return end
	local show = false

	if GetMinimapZoneText() == garrisonzones[1] or GetMinimapZoneText() == garrisonzones[E.myfaction == "Horde" and 2 or 3] then show = true end
	return show
end

function Gar:CreateToolbars()
	--  TODO: This GarrisonAnchor was global and dont think it was intended... keep an eye out for issues if any reported due to old module
	local GarrisonAnchor = CreateFrame("Frame", "SLE_GarrisonToolbarAnchor", E.UIParent)
	GarrisonAnchor:SetFrameStrata("BACKGROUND")
	GarrisonAnchor:Point("LEFT", E.UIParent, "LEFT", 24, 0);

	GarrisonAnchor.Bars = {}
	GarrisonAnchor.NumBars = 1
	GarrisonAnchor.BarsName = "SLE_GarrisonToolbar"

	GarrisonAnchor.ReturnDB = function() return E.db.sle.legacy.garrison.toolbar end
	GarrisonAnchor.ShouldShow = CanGarrisonBar
	GarrisonAnchor.InventroyCheck = function()
		local change = false
		for _, button in ipairs(GarrisonAnchor.Bars["SLE_GarrisonToolbar1"].Buttons) do
			button.items = GetItemCount(button.itemId)
			if not Tools.buttoncounts[button.itemId] then
				Tools.buttoncounts[button.itemId] = button.items
			end
			if button.items ~= Tools.buttoncounts[button.itemId] then
				change = true
				Tools.buttoncounts[button.itemId] = button.items
			end
			button.text:SetText(button.items)
			button.icon:SetDesaturated(button.items == 0)
			button.icon:SetAlpha(button.items == 0 and .25 or 1)
		end
		return change
	end
	GarrisonAnchor.EnableMover = function() return E.db.sle.legacy.garrison.toolbar.enable end
	GarrisonAnchor.UpdateBarLayout = Tools.UpdateBarLayout
	GarrisonAnchor.Resize = function(self)
		self:Size((E.db.sle.legacy.garrison.toolbar.buttonsize+(2 - E.Spacing))*7 - E.Spacing, E.db.sle.legacy.garrison.toolbar.buttonsize+(2 - E.Spacing) - E.Spacing)
	end

	local garrisonBar = CreateFrame("Frame", "SLE_GarrisonToolbar1", GarrisonAnchor)
	garrisonBar:SetFrameStrata("BACKGROUND")
	garrisonBar:SetPoint("CENTER", GarrisonAnchor, "CENTER", 0, 0)
	garrisonBar.id = 1
	garrisonBar.Items = {}
	garrisonBar.zonecheck = CanGarrisonBar

	for index = 1, #GarTools[1] do
		local itemID = GarTools[1][index]
		garrisonBar.Items[itemID] = itemID
	end
	GarrisonAnchor.Bars["SLE_GarrisonToolbar1"] = garrisonBar

	GarrisonAnchor.Resize(GarrisonAnchor)
	E:CreateMover(GarrisonAnchor, "SLE_GarrisonToolMover", L["S&L: Garrison Tools Bar"], nil, nil, nil, "ALL,S&L,S&L MISC")
	E:DisableMover("SLE_GarrisonToolMover")
	return GarrisonAnchor
end

function Gar:Initialize()
	if not SLE.initialized then return end
	Gar.db = E.db.sle.legacy.garrison
	Gar.clicked = false

	Tools:RegisterForBar(Gar.CreateToolbars)

	function Gar:ForUpdateAll()
		Gar.db = E.db.sle.legacy.garrison
	end

	self:RegisterEvent("SHIPMENT_CRAFTER_INFO");
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED");
end

SLE:RegisterModule(Gar:GetName())
