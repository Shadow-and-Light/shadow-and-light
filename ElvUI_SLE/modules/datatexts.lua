local SLE, T, E, L, V, P, G = unpack(select(2, ...))  
local DTP = SLE:NewModule('Datatexts', 'AceHook-3.0', 'AceEvent-3.0');
local DT = E:GetModule('DataTexts');
local _G = _G
local CreateFrame = CreateFrame
DTP.values = {
	[1] = {"TOPLEFT", 0, 3},
	[2] = {"TOP", -((E.eyefinity or E.screenwidth)/5), 3},
	[3] = {"TOP", 0, 1},
	[4] = {"TOP", ((E.eyefinity or E.screenwidth)/5), 3},
	[5] = {"TOPRIGHT", 0, 3},
	[6] = {"BOTTOM", -((E.eyefinity or E.screenwidth)/6 - 15), 3},
	[7] = {"BOTTOM", 0, 1},
	[8] = {"BOTTOM", ((E.eyefinity or E.screenwidth)/6 - 15), 3},
}
DTP.Names = {}

local function Bar_OnEnter(self)
	if DTP.db["panel"..self.Num].mouseover then
		E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	end
end

local function Button_OnEnter(self)
	local bar = self:GetParent()
	if DTP.db["panel"..bar.Num].mouseover then
		E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
	end
end

local function Bar_OnLeave(self)
	if DTP.db["panel"..self.Num].mouseover then
		E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
	end
end

local function Button_OnLeave(self)
	local bar = self:GetParent()
	if DTP.db["panel"..bar.Num].mouseover then
		E:UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
	end
end

function DTP:MouseoverHook()
	for panelName, panel in T.pairs(DT.RegisteredPanels) do
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			if DTP.Names[panelName] then 
				panel.dataPanels[pointIndex]:HookScript("OnEnter", Button_OnEnter)
				panel.dataPanels[pointIndex]:HookScript("OnLeave", Button_OnLeave)
			end
		end
	end
end

function DTP:CreatePanel(i)
	local panel = CreateFrame('Frame', "SLE_DataPanel_"..i, E.UIParent)
	panel.Num = i
	panel:SetFrameStrata('LOW')
	panel:Point(DTP.values[i][1], E.UIParent, DTP.values[i][1], DTP.values[i][2], 0); 
	DT:RegisterPanel(panel, DTP.values[i][3], 'ANCHOR_BOTTOM', 0, -4)
	panel:SetScript("OnEnter", Bar_OnEnter)
	panel:SetScript("OnLeave", Bar_OnLeave)
	panel:Hide()
	DTP.Names["SLE_DataPanel_"..i] = true

	return panel
end

function DTP:Mouseover(i)
	if DTP.db["panel"..i].mouseover then
		self["Panel_"..i]:SetAlpha(0)
	else
		self["Panel_"..i]:SetAlpha(1)
	end
end

function DTP:Size(i)
	self["Panel_"..i]:Size(DTP.db["panel"..i].width, 20)
	DT:UpdateAllDimensions()
end

function DTP:Toggle(i)
	if DTP.db["panel"..i].enabled then
		self["Panel_"..i]:Show()
		E:EnableMover(self["Panel_"..i].mover:GetName())
	else
		self["Panel_"..i]:Hide()
		E:DisableMover(self["Panel_"..i].mover:GetName())
	end
end

function DTP:PetHide(i)
	E.FrameLocks[self["Panel_"..i]] = DTP.db["panel"..i].pethide or nil
end

function DTP:Template(i)
	if not DTP.db["panel"..i].noback then
		if DTP.db["panel"..i].transparent then
			self["Panel_"..i]:SetTemplate("Transparent")
		else
			self["Panel_"..i]:SetTemplate("Default", true)
		end
	end
end

function DTP:Alpha(i)
	self["Panel_"..i]:SetAlpha(DTP.db["panel"..i].alpha)
end

function DTP:ChatResize()
	_G["LeftChatDataPanel"]:SetAlpha(DTP.db.leftchat.alpha)
	_G["LeftChatToggleButton"]:SetAlpha(DTP.db.leftchat.alpha)
	_G["RightChatDataPanel"]:SetAlpha(DTP.db.rightchat.alpha)
	_G["RightChatToggleButton"]:SetAlpha(DTP.db.rightchat.alpha)
	if not DTP.db.chathandle then return end
	_G["LeftChatDataPanel"]:Width(DTP.db.leftchat.width - E.Spacing*2)
	_G["RightChatDataPanel"]:Width(DTP.db.rightchat.width  - E.Spacing*2)
end

function DTP:CreateAndUpdatePanels()
	for i = 1, 8 do
		if not self["Panel_"..i] then self["Panel_"..i] = DTP:CreatePanel(i) end
		DTP:Size(i)
		DTP:Template(i)
		if not E.CreatedMovers["SLE_DataPanel_"..i.."_Mover"] then E:CreateMover(self["Panel_"..i], "SLE_DataPanel_"..i.."_Mover", L["SLE_DataPanel_"..i], nil, nil, nil, "ALL,S&L,S&L DT") end
		DTP:Toggle(i)
		DTP:PetHide(i)
		DTP:Alpha(i)
		DTP:Mouseover(i)
	end
	DTP:ChatResize()
end

function DTP:DeleteCurrencyEntry(data)
	if ElvDB['gold'][data.realm][data.name] then
		ElvDB['gold'][data.realm][data.name] = nil;
	end
	if ElvDB['class'] then
		if ElvDB['class'][data.realm][data.name] then
			ElvDB['class'][data.realm][data.name] = nil;
		end
	end
	if ElvDB['faction'] then
		if ElvDB['faction'][data.realm][FACTION_ALLIANCE][data.name] then
			ElvDB['faction'][data.realm][FACTION_ALLIANCE][data.name] = nil;
		end
		if ElvDB['faction'][data.realm][FACTION_HORDE][data.name] then
			ElvDB['faction'][data.realm][FACTION_HORDE][data.name] = nil;
		end
	end
	SLE.ACD:ConfigTableChanged(nil, "ElvUI")
end

function DTP:Initialize()
	if not SLE.initialized then return end

	function DTP:ForUpdateAll()
		DTP.db = E.db.sle.datatexts
		DTP:CreateAndUpdatePanels()
	end

	DTP:ForUpdateAll()
	--Datatexts
	DTP:HookTimeDT()
	DTP:HookDurabilityDT()
	DTP:CreateMailDT()
	DTP:CreateCurrencyDT()

	--Remove char
	local popup = E.PopupDialogs['SLE_CONFIRM_DELETE_CURRENCY_CHARACTER']
	popup.OnAccept = DTP.DeleteCurrencyEntry,
	
	hooksecurefunc(DT, "LoadDataTexts", DTP.MouseoverHook)
end

SLE:RegisterModule(DTP:GetName())