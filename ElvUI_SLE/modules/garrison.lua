local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule("Skins")
local G = E:GetModule("SLE_Garrison")

local n = 0
local buildID = {
    [8] = "War",
    [9] = "War",
    [10] = "War",
    [111] = "Trade",
    [144] = "Trade",
    [145] = "Trade",
}

function G:WorkOrderButtonCreate()
	local button = CreateFrame("Button", 'SLE_MaxWorkOrderButton', GarrisonCapacitiveDisplayFrame, "OptionsButtonTemplate");
	button:Point("RIGHT", GarrisonCapacitiveDisplayFrame.StartWorkOrderButton, "LEFT", -4, 0); 
	button:Width(50);
	button:Height(22);
	S:HandleButton(button)
	
	button.text = button:CreateFontString(nil, "OVERLAY", button)
	button.text:SetPoint("CENTER", button, "CENTER", -2, 0)
	button.text:FontTemplate()
	
	button:SetScript('OnClick', G.AutoOrderScript)
end

function G:GetNumOrders(maxShipments)
	if not maxShipments then return end
	local number = (maxShipments or 0) - (C_Garrison.GetNumPendingShipments() or 0)
	for i = 1, C_Garrison.GetNumShipmentReagents() do
		local name, texture, quality, needed, quantity, itemID = C_Garrison.GetShipmentReagentInfo(i);
		if (not name) then
	   		break;
	   	end
		local canDo = quantity/needed
		if canDo < number then number = floor(canDo) end
	end

	return number
end

function G:AutoOrderScript()
	local self = SLE_AutoOrderFrame
	
	if n <= 0 then self:SetScript("OnUpdate", nil); return end
	self.elapsed = 0
	self:SetScript("OnUpdate", function (self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > 0.2 then
			self.elapsed = 0;
			if n > 0 then 
				C_Garrison.RequestShipmentCreation()
			else
				self:SetScript("OnUpdate", nil);
				self:Disable();
			end
		end
	end)
end

function G:SHIPMENT_CRAFTER_OPENED(containerID)
	if E.db.sle.garrison.showOrderButton then
		if SLE_MaxWorkOrderButton then SLE_MaxWorkOrderButton:Show() end
	else
		if SLE_MaxWorkOrderButton then SLE_MaxWorkOrderButton:Hide() end
	end
	SLE_AutoOrderFrame:SetScript("OnUpdate", nil);
end

function G:SHIPMENT_CRAFTER_CLOSED()
	SLE_AutoOrderFrame:SetScript("OnUpdate", nil);
end

function G:SHIPMENT_CRAFTER_INFO(event, success, _, maxShipments, plotID)
	if not GarrisonCapacitiveDisplayFrame then return end
	n = G:GetNumOrders(maxShipments)
	local button = SLE_MaxWorkOrderButton
	
	local enabled = GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:IsEnabled()
	if button then button:SetEnabled(enabled) end
    if not enabled then
		SLE_AutoOrderFrame:SetScript ("OnUpdate", nil)
		if button then
			button.text:SetText(L["Max"])
			button.text:SetTextColor(0.6, 0.6, 0.6)
		end
        return
	else
		if button then
			button.text:SetText("x"..n)
			button.text:SetTextColor(1,0.9,0)
		end
    end
	
	if not E.db.sle.garrison.autoOrder then return end
	if not enabled then return end
	local ID = C_Garrison.GetOwnedBuildingInfo(plotID)
	local nope = buildID[ID]
	if nope then
		if E.db.sle.garrison['auto'..nope] then
			G:AutoOrderScript()
		end
	else
		G:AutoOrderScript()
	end
end

function G:ADDON_LOADED(event, name)
	if name == 'Blizzard_GarrisonUI' then
		G:WorkOrderButtonCreate()
		G:UnregisterEvent('ADDON_LOADED')
	end
end

function G:ShowButton()
	if E.db.sle.garrison.showOrderButton then
		if IsAddOnLoaded('Blizzard_GarrisonUI') and not SLE_MaxWorkOrderButton then
			G:WorkOrderButtonCreate()
		else
			G:RegisterEvent('ADDON_LOADED')
		end
	else
		G:UnregisterEvent('ADDON_LOADED')
	end
end

function G:Initialize()
	local f = CreateFrame("Frame", "SLE_AutoOrderFrame", GarrisonCapacitiveDisplayFrame)
	G:ShowButton()
	self:RegisterEvent("SHIPMENT_CRAFTER_INFO");
	self:RegisterEvent("SHIPMENT_CRAFTER_OPENED");
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED");
end