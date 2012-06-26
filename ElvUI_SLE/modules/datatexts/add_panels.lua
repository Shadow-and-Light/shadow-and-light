local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local DTP = E:NewModule('DTPanels', 'AceHook-3.0', 'AceEvent-3.0');
local LO = E:GetModule('Layout');

--Added function to create new panels
LO.InitializeDPE = LO.Initialize
function LO:Initialize()
	LO.InitializeDPE(self)
	DTP:CreateDataPanels()
	DTP:Resize()
	
	E:CreateMover(DP_1, "DP_1_Mover", L["DP_1"])
	E:CreateMover(DP_2, "DP_2_Mover", L["DP_2"])
	E:CreateMover(DP_3, "DP_3_Mover", L["DP_3"])
	E:CreateMover(DP_4, "DP_4_Mover", L["DP_4"])
	E:CreateMover(DP_5, "DP_5_Mover", L["DP_5"])
	E:CreateMover(Bottom_Panel, "Bottom_Panel_Mover", L["Bottom_Panel"])
	E:CreateMover(DP_6, "DP_6_Mover", L["DP_6"])
end

-- New panels
function DTP:CreateDataPanels()
	--the most left top panel
	local top_left_bar = CreateFrame('Frame', "DP_1", E.UIParent)
	top_left_bar:SetTemplate('Default', true)
	top_left_bar:SetFrameStrata('LOW')
	top_left_bar:Point("TOPLEFT", E.UIParent, "TOPLEFT", 0, 0); 
	E:GetModule('DataTexts'):RegisterPanel(DP_1, 3, 'ANCHOR_BOTTOM', 0, -4)
	top_left_bar:Hide()

	--top center
	local top_center_bar = CreateFrame('Frame', "Top_Center", E.UIParent)
	top_center_bar:SetTemplate('Default', true)
	top_center_bar:SetFrameStrata('LOW')
	top_center_bar:Point("TOP", E.UIParent, "TOP", 0, 0); 
	E:GetModule('DataTexts'):RegisterPanel(Top_Center, 1, 'ANCHOR_BOTTOM', 0, -4)
	top_center_bar:Hide()
	
	--top left
	local top_center_left_bar = CreateFrame('Frame', "DP_2", E.UIParent)
	top_center_left_bar:SetTemplate('Default', true)
	top_center_left_bar:SetFrameStrata('LOW')
	top_center_left_bar:Point("TOPRIGHT", Top_Center, "TOPLEFT", -1, 0)
	E:GetModule('DataTexts'):RegisterPanel(DP_2, 3, 'ANCHOR_BOTTOM', 0, -4)
	top_center_left_bar:Hide()
	
	--top right
	local top_center_right_bar = CreateFrame('Frame', "DP_3", E.UIParent)
	top_center_right_bar:SetTemplate('Default', true)
	top_center_right_bar:SetFrameStrata('LOW')
	top_center_right_bar:Point("TOPLEFT", Top_Center, "TOPRIGHT", 1, 0); 
	E:GetModule('DataTexts'):RegisterPanel(DP_3, 3, 'ANCHOR_BOTTOM', 0, -4)
	top_center_right_bar:Hide()
	
	--the most right top panel
	local top_right_bar = CreateFrame('Frame', "DP_4", E.UIParent)
	top_right_bar:SetTemplate('Default', true)
	top_right_bar:SetFrameStrata('LOW')
	top_right_bar:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", 0, 0); 
	E:GetModule('DataTexts'):RegisterPanel(DP_4, 3, 'ANCHOR_BOTTOM', 0, -4)
	top_right_bar:Hide()
	
	--bottom center
	local map = CreateFrame('Frame', 'Bottom_Panel', E.UIParent)
	map:SetTemplate('Default', true)
	map:SetFrameStrata('LOW')
	map:Point("BOTTOM", E.UIParent, "BOTTOM", 0, 0); 
	E:GetModule('DataTexts'):RegisterPanel(Bottom_Panel, 1, 'ANCHOR_BOTTOM', 0, -4)
	map:Hide()
	
	--bottom left
	local top_bar = CreateFrame('Frame', 'DP_5', E.UIParent)
	top_bar:SetTemplate('Default', true)
	top_bar:SetFrameStrata('LOW')
	top_bar:Point("RIGHT", Bottom_Panel, "LEFT", -1, 0); 
	E:GetModule('DataTexts'):RegisterPanel(DP_5, 3, 'ANCHOR_BOTTOM', 0, -4)
	top_bar:Hide()
	
	--bottom right
	local bottom_bar = CreateFrame('Frame', "DP_6", E.UIParent)
	bottom_bar:SetTemplate('Default', true)
	bottom_bar:SetFrameStrata('LOW')
	bottom_bar:Point("LEFT", Bottom_Panel, "RIGHT", 1, 0); 
	E:GetModule('DataTexts'):RegisterPanel(DP_6, 3, 'ANCHOR_BOTTOM', 0, -4)
	bottom_bar:Hide()
end

function DTP:Resize()
	DP_5:Size(E.db.dpe.datatext.dp5.width, 20)
	DP_6:Size(E.db.dpe.datatext.dp6.width, 20)
	Bottom_Panel:Size(E.db.dpe.datatext.bottom.width, 20)
	DP_1:Size(E.db.dpe.datatext.dp1.width, 20)
	DP_4:Size(E.db.dpe.datatext.dp4.width, 20)
	DP_3:Size(E.db.dpe.datatext.dp3.width, 20)
	DP_2:Size(E.db.dpe.datatext.dp2.width, 20)
	Top_Center:Size(E.db.dpe.datatext.top.width, 20)
	E:GetModule('DataTexts'):UpdateAllDimensions()
end

function DTP:ChatResize()
	LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -(E.db.general.panelWidth - E.db.dpe.datatext.chatleft.width), -1)
	RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMLEFT', E.db.general.panelWidth - E.db.dpe.datatext.chatright.width, -21)
end

--Showing panels
function DTP:ExtraDataBarSetup()
	if E.db.dpe.datatext.dp1.enabled then
		DP_1:Show()
	else
		DP_1:Hide()
	end
	
	if E.db.dpe.datatext.dp2.enabled then
		DP_2:Show()
	else
		DP_2:Hide()
	end
	
	if E.db.dpe.datatext.dp3.enabled then
		DP_3:Show()
	else
		DP_3:Hide()
	end
	
	if E.db.dpe.datatext.dp4.enabled then
		DP_4:Show()
	else
		DP_4:Hide()
	end
	
	if E.db.dpe.datatext.dp5.enabled then
		DP_5:Show()
	else
		DP_5:Hide()
	end
	
	if E.db.dpe.datatext.dp6.enabled then
		DP_6:Show()
	else
		DP_6:Hide()
	end
	
	if E.db.dpe.datatext.bottom.enabled then
		Bottom_Panel:Show()
	else
		Bottom_Panel:Hide()
	end
Top_Center:Show()
end

function DTP:Update()
	DTP:ExtraDataBarSetup()
	DTP:Resize()
end

--Renew panels after loading screens
function DTP:PLAYER_ENTERING_WORLD(...)
DTP:ExtraDataBarSetup()
self:UnregisterEvent("PLAYER_ENTERING_WORLD");
end
DTP:RegisterEvent('PLAYER_ENTERING_WORLD')

E:RegisterModule(DTP:GetName())