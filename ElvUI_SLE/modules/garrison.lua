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
}

function G:SHIPMENT_CRAFTER_INFO(event, success, _, maxShipments, plotID)
	if not GarrisonCapacitiveDisplayFrame then return end
	local n = GarrisonCapacitiveDisplayFrame.available or 0
	
	local enabled = GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:IsEnabled()
	
	if not E.db.sle.garrison.autoOrder then return end
	if not enabled then return end
	local ID = C_Garrison.GetOwnedBuildingInfo(plotID)
	local nope = buildID[ID]
	if nope then
		if E.db.sle.garrison['auto'..nope] then
			C_Garrison.RequestShipmentCreation(n)
		end
	else
		C_Garrison.RequestShipmentCreation(n)
	end
end

function G:Initialize()
	self:RegisterEvent("SHIPMENT_CRAFTER_INFO");
end