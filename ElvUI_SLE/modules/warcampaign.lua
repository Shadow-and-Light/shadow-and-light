local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local mod = SLE:NewModule('WarCampaign','AceHook-3.0', 'AceEvent-3.0')
local clicked

function mod:SHIPMENT_CRAFTER_INFO(event, success, shipmentCount, maxShipments, ownedShipments, plotID)
	if not _G["GarrisonCapacitiveDisplayFrame"] then return end --Just in case
	if GarrisonCapacitiveDisplayFrame.containerID ~= 239 then return end
	local n = _G["GarrisonCapacitiveDisplayFrame"].available or 0
	if clicked or n == 0 or not E.db.sle.legacy.warwampaign.autoOrder.enable then return end
	clicked = true
	-- local ID = C_Garrison.GetOwnedBuildingInfo(plotID)
	-- local nope = buildID[ID]
	-- if nope then
		-- if Gar.db.autoOrder["auto"..nope] then
			-- _G["GarrisonCapacitiveDisplayFrame"].CreateAllWorkOrdersButton:Click()
		-- end
	-- else
		_G["GarrisonCapacitiveDisplayFrame"].CreateAllWorkOrdersButton:Click()
	-- end
end

function mod:SHIPMENT_CRAFTER_CLOSED()
	clicked = false
end

function mod:Initialize()
	if not SLE.initialized then return end

	clicked = false

	self:RegisterEvent("SHIPMENT_CRAFTER_INFO");
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED");
end

SLE:RegisterModule(mod:GetName())