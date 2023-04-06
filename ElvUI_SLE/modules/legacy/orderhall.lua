local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local OH = SLE.OrderHall

local _G = _G
local C_Garrison = C_Garrison

function OH:SHIPMENT_CRAFTER_INFO(event, success, shipmentCount, maxShipments, ownedShipments, plotID)
	if not _G["GarrisonCapacitiveDisplayFrame"] then return end --Just in case
	if not C_Garrison.IsPlayerInGarrison(3) then return end
	local n = _G["GarrisonCapacitiveDisplayFrame"].available or 0
	if OH.clicked or n == 0 or not OH.db.autoOrder.enable then return end
	OH.clicked = true
	local _, _, _, _, followerID = C_Garrison.GetShipmentItemInfo()
	if followerID then
		_G["GarrisonCapacitiveDisplayFrame"].CreateAllWorkOrdersButton:Click()
	else
		if OH.db.autoOrder.autoEquip then
			_G["GarrisonCapacitiveDisplayFrame"].CreateAllWorkOrdersButton:Click()
		end
	end
end

function OH:SHIPMENT_CRAFTER_CLOSED()
	OH.clicked = false
end

function OH:Initialize()
	if not SLE.initialized then return end
	if E.db.sle.orderhall then E.db.sle.orderhall = nil end
	OH.db = E.db.sle.legacy.orderhall
	OH.clicked = false

	function OH:ForUpdateAll()
		if E.db.sle.orderhall then E.db.sle.orderhall = nil end
		OH.db = E.db.sle.legacy.orderhall
	end

	self:RegisterEvent("SHIPMENT_CRAFTER_INFO")
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED")
end

SLE:RegisterModule(OH:GetName())
