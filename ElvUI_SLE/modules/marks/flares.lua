local E, L, V, P, G, _ = unpack(ElvUI);
local RF = E:NewModule('RaidFlares', 'AceHook-3.0', 'AceEvent-3.0');

BINDING_HEADER_SHADOWLIGHT_WORLDMARKER = GetAddOnMetadata(..., "Title");
--BINDING_HEADER_SHADOWLIGHT_WORLDMARKER = string.format("|cffe1a500w|cff69ccf0Marker|r - %s",L["World markers"]);
_G["BINDING_NAME_CLICK SquareFlareMarker:LeftButton"] = L["Square"];
_G["BINDING_NAME_CLICK TriangleFlareMarker:LeftButton"] = L["Triangle"];
_G["BINDING_NAME_CLICK DiamondFlareMarker:LeftButton"] = L["Diamond"];
_G["BINDING_NAME_CLICK CrossFlareMarker:LeftButton"] = L["Cross"];
_G["BINDING_NAME_CLICK StarFlareMarker:LeftButton"] = L["Star"];

local mainFlares = CreateFrame("Frame", "Main_Flares", E.UIParent)
local f1 = CreateFrame("Button", "SquareFlareMarker", Main_Flares, "SecureActionButtonTemplate")
local f2 = CreateFrame("Button", "TriangleFlareMarker", Main_Flares, "SecureActionButtonTemplate")
local f3 = CreateFrame("Button", "DiamondFlareMarker", Main_Flares, "SecureActionButtonTemplate")
local f4 = CreateFrame("Button", "CrossFlareMarker", Main_Flares, "SecureActionButtonTemplate")
local f5 = CreateFrame("Button", "StarFlareMarker", Main_Flares, "SecureActionButtonTemplate")

local FlareB = {f1,f2,f3,f4,f5}

function RF:CreateFrame()
	mainFlares:Point("CENTER", E.UIParent, "CENTER", 0, 40);
	mainFlares:SetFrameStrata('LOW');
	mainFlares:CreateBackdrop();
	mainFlares.backdrop:SetAllPoints();
	mainFlares:Hide();
end

function RF:SetupButton(button, flare)
	button:CreateBackdrop()
	button.backdrop:SetAllPoints()
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext",  '/wm '..flare..'')   
	button.tex = button:CreateTexture(nil, 'OVERLAY')
	--button.tex:Point('TOPLEFT', button, 'TOPLEFT', 2, -2)
	button.tex:Point('TOPLEFT', button, 'TOPLEFT', 0, -1)
	--button.tex:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 2)
	button.tex:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 1)
	if button == f1 then     
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_6")
	elseif button == f2 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_4")
	elseif button == f3 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_3")
	elseif button == f4 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_7")
	elseif button == f5 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_1")
	end
end

function RF:CreateButtons()
	for i = 1, 5 do
		RF:SetupButton(FlareB[i], i)
	end
end

function RF:FrameButtonsSize()
	for i = 1, 5 do
		FlareB[i]:Size(E.db.sle.flares.size)
	end
end

function RF:FrameButtonsGrowth()
	local db = E.db.sle.flares
	local size = db.size
	local width, height, x, y, anchor, point
	local t = {5*size+8,size+4,"LEFT","RIGHT","TOP","BOTTOM",1,0,-1}
	for i = 1, 5 do
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

	for i = 1, 5 do
		if i == 1 then
			FlareB[i]:Point(anchor, Main_Flares, anchor, 2 * x, 2 * y)
		else
			FlareB[i]:Point(anchor, FlareB[i-1], point, x, y)
		end
	end
end

function RF:UpdateVisibility()
	local inInstance, instanceType = IsInInstance()
	local db = E.db.sle.flares
	if db.enabled then
		if (inInstance and instanceType ~= "pvp") and db.showinside then
			E.FrameLocks['Main_Flares'] = true
			mainFlares:Show()
		elseif not inInstance and db.showinside then
			E.FrameLocks['Main_Flares'] = nil
			mainFlares:Hide()
		elseif not db.showinside then
			E.FrameLocks['Main_Flares'] = true
			mainFlares:Show()
		end
	else
		E.FrameLocks['Main_Flares'] = true
		mainFlares:Hide()
	end
end

function RF:Backdrop()
	if E.db.sle.flares.backdrop then
		mainFlares.backdrop:Show()
	else
		mainFlares.backdrop:Hide()
	end
end

function RF:Update()
   RF:FrameButtonsSize()
   RF:FrameButtonsGrowth()
   RF:UpdateVisibility()
   RF:Backdrop()
end

function RF:Initialize()
   RF:CreateFrame()
   RF:Update()
   RF:CreateButtons()
   self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateVisibility");
   
   E:CreateMover(mainFlares, "FlareMover", "RF", nil, nil, nil, "ALL,S&L,S&L MISC")
end

E:RegisterModule(RF:GetName())