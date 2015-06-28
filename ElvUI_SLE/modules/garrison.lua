local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule("Skins")
local G = E:GetModule("SLE_Garrison")

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

function G:SHIPMENT_CRAFTER_INFO(event, success, _, maxShipments, plotID)
	if not GarrisonCapacitiveDisplayFrame then return end --Just in case
	local n = GarrisonCapacitiveDisplayFrame.available or 0
	if G.clicked or n == 0 or not E.db.sle.garrison.autoOrder then return end
	G.clicked = true
	local ID = C_Garrison.GetOwnedBuildingInfo(plotID)
	local nope = buildID[ID]
	if nope then
		if E.db.sle.garrison['auto'..nope] then
			GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton:Click()
		end
	else
		GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton:Click()
	end
end

function G:SHIPMENT_CRAFTER_CLOSED()
	G.clicked = false
end

function G:Initialize()
	G.clicked = false

	self:RegisterEvent("SHIPMENT_CRAFTER_INFO");
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED");
end