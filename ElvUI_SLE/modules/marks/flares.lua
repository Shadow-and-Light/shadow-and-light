local E, L, V, P, G, _ = unpack(ElvUI);
local RF = E:NewModule('SLE_RaidFlares', 'AceHook-3.0', 'AceEvent-3.0');
local template = "SecureActionButtonTemplate"

BINDING_HEADER_SHADOWLIGHT_WORLDMARKER = "|cff1784d1Shadow & Light|r"
_G["BINDING_NAME_CLICK SquareFlareMarker:LeftButton"] = L["Square Flare"];
_G["BINDING_NAME_CLICK TriangleFlareMarker:LeftButton"] = L["Triangle Flare"];
_G["BINDING_NAME_CLICK DiamondFlareMarker:LeftButton"] = L["Diamond Flare"];
_G["BINDING_NAME_CLICK CrossFlareMarker:LeftButton"] = L["Cross Flare"];
_G["BINDING_NAME_CLICK StarFlareMarker:LeftButton"] = L["Star Flare"];

local mainFlares, f1, f2, f3, f4, f5, f6, FlareB 

function RF:CreateFrame()
	mainFlares = CreateFrame("Frame", "Main_Flares", E.UIParent)
	mainFlares:Point("CENTER", E.UIParent, "CENTER", 0, 40);
	mainFlares:SetFrameStrata('LOW');
	mainFlares:CreateBackdrop();
	mainFlares.backdrop:SetAllPoints();
	mainFlares:Hide();
	
	f1 = CreateFrame("Button", "SquareFlareMarker", Main_Flares, template)
	f2 = CreateFrame("Button", "TriangleFlareMarker", Main_Flares, template)
	f3 = CreateFrame("Button", "DiamondFlareMarker", Main_Flares, template)
	f4 = CreateFrame("Button", "CrossFlareMarker", Main_Flares, template)
	f5 = CreateFrame("Button", "StarFlareMarker", Main_Flares, template)
	f6 = CreateFrame("Button", "ClearFlaresMarker", Main_Flares, template)
	
	FlareB = {f1,f2,f3,f4,f5,f6}
end

function RF:SetupButton(button, flare)
	if not mainFlares then return end
	button:CreateBackdrop()
	button.backdrop:SetAllPoints()
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext", flare)
	button:RegisterForClicks("AnyDown")

	button.tex = button:CreateTexture(nil, 'OVERLAY')
	button.tex:Point('TOPLEFT', button, 'TOPLEFT', 2, -2)
	button.tex:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 2)
	if button == f1 then     
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_6")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Square World Marker"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	elseif button == f2 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_4")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Triangle World Marker"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	elseif button == f3 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_3")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Diamond World Marker"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	elseif button == f4 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_7")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Cross World Marker"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	elseif button == f5 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_1")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Star World Marker"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	elseif button == f6 then
		button.tex:SetTexture("Interface\\AddOns\\ElvUI_SLE\\media\\textures\\clearmarker.blp")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Clear World Markers"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
end

function RF:CreateButtons()
	if not mainFlares then return end
	RF:SetupButton(f1, "/clearworldmarker 1\n/worldmarker 1")
	RF:SetupButton(f2, "/clearworldmarker 2\n/worldmarker 2")
	RF:SetupButton(f3, "/clearworldmarker 3\n/worldmarker 3")
	RF:SetupButton(f4, "/clearworldmarker 4\n/worldmarker 4")
	RF:SetupButton(f5, "/clearworldmarker 5\n/worldmarker 5")
	RF:SetupButton(f6, "/clearworldmarker all")
end

function RF:FrameButtonsSize()
	if not mainFlares then return end
	for i = 1, 6 do
		FlareB[i]:Size(E.db.sle.flares.size)
	end
end

function RF:FrameButtonsGrowth()
	if not mainFlares then return end
	local db = E.db.sle.flares
	local size = db.size
	local width, height, x, y, anchor, point
	local t = {6*size+9,size+4,"LEFT","RIGHT","TOP","BOTTOM",1,0,-1}
	for i = 1, 6 do
		FlareB[i]:ClearAllPoints()
	end

	if db.growth == "RIGHT" then
		width, height, anchor, point, _, _, x, y = unpack(t)
	elseif db.growth == "LEFT" then
		width, height, point, anchor, _, _, _, y, x = unpack(t)
	elseif db.growth == "UP" then
		height, width, _, _, point, anchor, y, x = unpack(t)
	elseif db.growth == "DOWN" then
		height, width, _, _, anchor, point, _, x, y = unpack(t)
	end

	mainFlares:SetWidth(width)
	mainFlares:SetHeight(height)

	for i = 1, 6 do
		if i == 1 then
			FlareB[i]:Point(anchor, Main_Flares, anchor, 2 * x, 2 * y)
		else
			FlareB[i]:Point(anchor, FlareB[i-1], point, x, y)
		end
	end
end

function RF:UpdateVisibility()
	if not mainFlares then return end
	local inInstance, instanceType = IsInInstance()
	local db = E.db.sle.flares
	local show = false
	
	if (inInstance and instanceType ~= "pvp") and db.showinside then
		show = true
	elseif not inInstance and db.showinside then
		show = false
	elseif not db.showinside then
		show = true
	end

	if show then
		E.FrameLocks['Main_Flares'] = true
		mainFlares:Show()
	else
		E.FrameLocks['Main_Flares'] = nil
		mainFlares:Hide()
	end
end

function RF:Backdrop()
	if not mainFlares then return end
	if E.db.sle.flares.backdrop then
		mainFlares.backdrop:Show()
	else
		mainFlares.backdrop:Hide()
	end
end

function RF:Update()
	if not mainFlares then return end
	RF:FrameButtonsSize()
	RF:FrameButtonsGrowth()
	RF:UpdateVisibility()
	RF:Backdrop()
end

function RF:Initialize()
	if not E.private.sle.marks.flares then return end
	RF:CreateFrame()
	RF:Update()
	RF:CreateButtons()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateVisibility");
   
	E:CreateMover(mainFlares, "FlareMover", "RF", nil, nil, nil, "ALL,S&L,S&L MISC")
end

E:RegisterModule(RF:GetName())