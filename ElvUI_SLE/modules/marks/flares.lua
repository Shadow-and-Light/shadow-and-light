local E, L, V, P, G = unpack(ElvUI);
local RF = E:GetModule('SLE_RaidFlares');
local template = "SecureActionButtonTemplate"

BINDING_HEADER_SHADOWLIGHT_WORLDMARKER = "|cff1784d1Shadow & Light|r"
_G["BINDING_NAME_CLICK SquareFlareMarker:LeftButton"] = L["Square Flare"];
_G["BINDING_NAME_CLICK TriangleFlareMarker:LeftButton"] = L["Triangle Flare"];
_G["BINDING_NAME_CLICK DiamondFlareMarker:LeftButton"] = L["Diamond Flare"];
_G["BINDING_NAME_CLICK CrossFlareMarker:LeftButton"] = L["Cross Flare"];
_G["BINDING_NAME_CLICK StarFlareMarker:LeftButton"] = L["Star Flare"];
_G["BINDING_NAME_CLICK CircleFlareMarker:LeftButton"] = L["Circle Flare"];
_G["BINDING_NAME_CLICK MoonFlareMarker:LeftButton"] = L["Moon Flare"];
_G["BINDING_NAME_CLICK SkullFlareMarker:LeftButton"] = L["Skull Flare"];

local mainFlares, f1, f2, f3, f4, f5, f6, f7, f8, f9, FlareB 

local function CreateFrames()
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
	f7 = CreateFrame("Button", "MoonFlareMarker", Main_Flares, template)
	f8 = CreateFrame("Button", "SkullFlareMarker", Main_Flares, template)
	f9 = CreateFrame("Button", "ClearFlaresMarker", Main_Flares, template)
	
	FlareB = {f1,f2,f3,f4,f5,f6,f7,f8,f9}
end

local function SetupButton(button, flare)
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
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_2")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Circle World Marker"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	elseif button == f7 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_5")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Moon World Marker"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	elseif button == f8 then
		button.tex:SetTexture("INTERFACE/TARGETINGFRAME/UI-RaidTargetingIcon_8")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Skull World Marker"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	elseif button == f9 then
		button.tex:SetTexture("Interface\\AddOns\\ElvUI_SLE\\media\\textures\\clearmarker.blp")
		button:SetScript("OnEnter", function(self) if (E.db.sle.flares.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Clear World Markers"]); GameTooltip:Show() end end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
end

local function CreateButtons()
	if not mainFlares then return end
	for i = 1, 9 do
		if i ~= 9 then
			SetupButton(FlareB[i], "/clearworldmarker".. i .."\n/worldmarker ".. i)
		else
			SetupButton(FlareB[i], "/clearworldmarker all")
		end
	end
end

local function FrameButtonsSize()
	if not mainFlares then return end
	for i = 1, 9 do
		FlareB[i]:Size(E.db.sle.flares.size)
	end
end

local function FrameButtonsGrowth()
	if not mainFlares then return end
	local db = E.db.sle.flares
	local size = db.size
	local width, height, x, y, anchor, point
	local t = {9*size+9,size+4,"LEFT","RIGHT","TOP","BOTTOM",1,0,-1}
	for i = 1, 9 do
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

	for i = 1, 9 do
		if i == 1 then
			FlareB[i]:Point(anchor, Main_Flares, anchor, 2 * x, 2 * y)
		else
			FlareB[i]:Point(anchor, FlareB[i-1], point, x, y)
		end
	end
end

local function Mouseover()
	if not mainFlares then return end
	local db = E.db.sle.flares
	if db.mouseover then
		mainFlares:SetScript("OnUpdate", function(self)
			if MouseIsOver(self) then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			else
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			end
		end)
	else
		mainFlares:SetScript("OnUpdate", nil)
		if mainFlares:IsShown() then
			UIFrameFadeIn(mainFlares, 0.2, mainFlares:GetAlpha(), 1)
		end
	end
end

local function UpdateVisibility()
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
		for i = 1, 9 do
			FlareB[i]:Show()
		end
	else
		E.FrameLocks['Main_Flares'] = nil
		mainFlares:Hide()
		for i = 1, 9 do
			FlareB[i]:Hide()
		end
	end
	Mouseover()
end

local function Backdrop()
	if not mainFlares then return end
	if E.db.sle.flares.backdrop then
		mainFlares.backdrop:Show()
	else
		mainFlares.backdrop:Hide()
	end
end

function RF:Update()
	if not mainFlares then return end
	FrameButtonsSize()
	FrameButtonsGrowth()
	UpdateVisibility()
	Backdrop()
end

function RF:Initialize()
	if not E.private.sle.marks.flares then return end
	CreateFrames()
	RF:Update()
	CreateButtons()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateVisibility);
   
	E:CreateMover(mainFlares, "FlareMover", "RF", nil, nil, nil, "ALL,S&L,S&L MISC")
end