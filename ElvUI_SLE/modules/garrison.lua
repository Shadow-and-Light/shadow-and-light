local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Gar = SLE:NewModule("Garrison", 'AceEvent-3.0')
local _G = _G
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

function Gar:SHIPMENT_CRAFTER_INFO(event, success, _, maxShipments, plotID)
	if not _G["GarrisonCapacitiveDisplayFrame"] then return end --Just in case
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

function Gar:Initialize()
	if not SLE.initialized then return end
	Gar.db = E.db.sle.legacy.garrison
	Gar.clicked = false

	function Gar:ForUpdateAll()
		Gar.db = E.db.sle.legacy.garrison
	end

	self:RegisterEvent("SHIPMENT_CRAFTER_INFO");
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED");
end

SLE:RegisterModule(Gar:GetName())