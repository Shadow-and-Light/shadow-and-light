local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local OH = SLE:NewModule("OrderHall", 'AceEvent-3.0')
local _G = _G
local C_Garrison = C_Garrison

function OH:SHIPMENT_CRAFTER_INFO(event, success, _, maxShipments, plotID)
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
	OH.db = E.db.sle.orderhall
	OH.clicked = false

	function OH:ForUpdateAll()
		OH.db = E.db.sle.orderhall
	end

	self:RegisterEvent("SHIPMENT_CRAFTER_INFO");
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED");
end

SLE:RegisterModule(OH:GetName())