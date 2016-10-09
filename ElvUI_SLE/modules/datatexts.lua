local SLE, T, E, L, V, P, G = unpack(select(2, ...))  
local DTP = SLE:NewModule('Datatexts', 'AceHook-3.0', 'AceEvent-3.0');
local DT, MM = SLE:GetElvModules("DataTexts", "Minimap");
--GLOBALS: ElvDB, hooksecurefunc
local _G = _G
local CreateFrame = CreateFrame
local FACTION_ALLIANCE, FACTION_HORDE = FACTION_ALLIANCE, FACTION_HORDE

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
DTP.GoldCache = {}

local function Bar_OnEnter(self)
	if DTP.db["panel"..self.Num].mouseover then
		E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), DTP.db["panel"..self.Num].alpha)
	end
end

local function Button_OnEnter(self)
	local bar = self:GetParent()
	if DTP.db["panel"..bar.Num].mouseover then
		E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), DTP.db["panel"..bar.Num].alpha)
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

local OnLoadThrottle = true
function DTP:LoadDTHook()
	local SLE_Cur_Selected = false
	T.twipe(DTP.GoldCache)
	for panelName, panel in T.pairs(DT.RegisteredPanels) do
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			if DTP.Names[panelName] then 
				panel.dataPanels[pointIndex]:HookScript("OnEnter", Button_OnEnter)
				panel.dataPanels[pointIndex]:HookScript("OnLeave", Button_OnLeave)
			end
			for option, value in T.pairs(DT.db.panels) do
				if value and type(value) == 'table' then
					if option == panelName and DT.db.panels[option][pointIndex] and DT.db.panels[option][pointIndex] == "Gold" then
						DTP.GoldCache[panelName] = panel.dataPanels[pointIndex]
					elseif option == panelName and DT.db.panels[option][pointIndex] and DT.db.panels[option][pointIndex] == "S&L Currency" then
						SLE_Cur_Selected = true
					end
				elseif value and type(value) == 'string' and value == "Gold" then
					if DT.db.panels[option] == "Gold" and option == panelName then
						DTP.GoldCache[panelName] = panel.dataPanels[pointIndex]
					end
				elseif value and type(value) == 'string' and value == "S&L Currency" then
					if DT.db.panels[option] == "Gold" and option == panelName then
						SLE_Cur_Selected = true
					end
				end
			end
		end
	end
	if OnLoadThrottle then
		OnLoadThrottle = false
		if SLE_Cur_Selected then
			for k, v in T.pairs(DTP.GoldCache) do
				local message = T.format(L["SLE_DT_CURRENCY_WARNING_GOLD"], "|cff1784d1"..L[k].."|r")
				SLE:ErrorPrint(message)
				if v then v:UnregisterAllEvents() end
			end
		end
		E:Delay(1, function() OnLoadThrottle = true end)
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
		self["Panel_"..i]:SetAlpha(DTP.db["panel"..i].alpha)
	end
end

function DTP:Size(i)
	self["Panel_"..i]:Size(DTP.db["panel"..i].width, 20)
	DT:UpdateAllDimensions()
end

function DTP:Toggle(i)
	if DTP.db["panel"..i].enabled then
		self["Panel_"..i]:Show()
		if DTP.db["panel"..i].mouseover then Bar_OnLeave(self["Panel_"..i]) end
		E:EnableMover(self["Panel_"..i].mover:GetName())
	else
		self["Panel_"..i]:Hide()
		E:DisableMover(self["Panel_"..i].mover:GetName())
	end
end

function DTP:PetHide(i)
	if DTP.db["panel"..i].pethide then
		E:RegisterPetBattleHideFrames(self["Panel_"..i], E.UIParent, "LOW")
	else
		E:UnregisterPetBattleHideFrames(self["Panel_"..i])
	end
end

function DTP:Template(i)
	if DTP.db["panel"..i].transparent then
		self["Panel_"..i]:SetTemplate(DTP.db["panel"..i].noback and "NoBackdrop" or "Transparent")
	else
		self["Panel_"..i]:SetTemplate(DTP.db["panel"..i].noback and "NoBackdrop" or "Default", true)
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
	--A lot of weird math to prevent chat frames from flying around the place
	if DTP.db.chathandle and E.db.datatexts.leftChatPanel then 
		_G["LeftChatDataPanel"]:Width(DTP.db.leftchat.width - E.Spacing*2)
	else
		_G["LeftChatDataPanel"]:Width(E.db.chat.panelWidth - (2*(E.Border*3 - E.Spacing) + 16))
	end
	if DTP.db.chathandle and E.db.datatexts.rightChatPanel then 
		_G["RightChatDataPanel"]:Width(DTP.db.rightchat.width  - E.Spacing*2)
	else
		_G["RightChatDataPanel"]:Width(((E.db.chat.separateSizes and E.db.chat.panelWidthRight) or E.db.chat.panelWidth) - (2*(E.Border*3 - E.Spacing) + 16))
	end
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
	
	-- hooksecurefunc(DT, "LoadDataTexts", DTP.MouseoverHook)
	hooksecurefunc(DT, "LoadDataTexts", DTP.LoadDTHook)
	-- :UpdateSettings()
	hooksecurefunc(MM, "UpdateSettings", DTP.LoadDTHook)
	DTP:LoadDTHook()
end

SLE:RegisterModule(DTP:GetName())