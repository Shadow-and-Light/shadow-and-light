local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DTP = SLE:NewModule('Datatexts', 'AceHook-3.0', 'AceEvent-3.0');
local DT, MM = SLE:GetElvModules("DataTexts", "Minimap");
--GLOBALS: ElvDB, hooksecurefunc
local _G = _G
local CreateFrame = CreateFrame
local FACTION_ALLIANCE, FACTION_HORDE = FACTION_ALLIANCE, FACTION_HORDE

--Datapanels creation templates. Appropriate info is unpacked by panel id.
DTP.template = {
	[1] = { point = "TOPLEFT", x = 0, numSlots = 3},
	[2] = { point = "TOP", x = -((E.eyefinity or E.screenwidth)/5), numSlots = 3},
	[3] = { point = "TOP", x = 0, numSlots = 1},
	[4] = { point = "TOP", x = ((E.eyefinity or E.screenwidth)/5), numSlots = 3},
	[5] = { point = "TOPRIGHT", x = 0, numSlots = 3},
	[6] = { point = "BOTTOM", x = -((E.eyefinity or E.screenwidth)/6 - 15), numSlots = 3},
	[7] = { point = "BOTTOM", x = 0, numSlots = 1},
	[8] = { point = "BOTTOM", x = ((E.eyefinity or E.screenwidth)/6 - 15), numSlots = 3},
}
DTP.Names = {}
--Table to remember where default Gold DT is
DTP.GoldCache = {}

--Mouseover functions for panels and datatexts on them
local function SubDTAlpha(panel, alpha)
	for slot = 1, panel.numPoints do
		local location = DT.PointLocation[slot]
		panel.dataPanels[location]:SetAlpha(alpha)
	end
end

local function Bar_OnEnter(self)
	if not self.Num then return end
	if not DTP.db["panel"..self.Num] then return end
	if DTP.db["panel"..self.Num].mouseover then
		E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), DTP.db["panel"..self.Num].alpha)
		SubDTAlpha(self, DTP.db["panel"..self.Num].alpha)
	end
end

local function Bar_OnLeave(self, settingForce)
	if not self.Num then return end
	if not DTP.db["panel"..self.Num] then return end
	if DTP.db["panel"..self.Num].mouseover then
		E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		if settingForce then SubDTAlpha(self, DTP.db["panel"..self.Num].alpha) end
		SubDTAlpha(self, 0)
	end
end

local function Button_OnEnter(self)
	local bar = self:GetParent()
	if not bar.Num then return end
	if not DTP.db["panel"..bar.Num] then return end
	if DTP.db["panel"..bar.Num].mouseover then
		E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), DTP.db["panel"..bar.Num].alpha)
		SubDTAlpha(bar, DTP.db["panel"..bar.Num].alpha)
	end
end

local function Button_OnLeave(self)
	local bar = self:GetParent()
	if not bar.Num then return end
	if not DTP.db["panel"..bar.Num] then return end
	if DTP.db["panel"..bar.Num].mouseover then
		E:UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
		SubDTAlpha(bar, 0)
	end
end

--The hook to core DT:LoadDataTexts function
local OnLoadThrottle = true
function DTP:LoadDTHook()
	--Is S&L's currency dt set anywhere
	local IsCurrencyDTSelected = false
	--Wipe the table. We assume after last settings change there is no default gold DTs
	T.twipe(DTP.GoldCache)
	--Going through all registered datapanels
	for panelName, panel in T.pairs(DT.RegisteredPanels) do
		for slot = 1, panel.numPoints do
			local location = DT.PointLocation[slot]
			--If it is S&L's panel hook scripts for show/hide on mouseover
			if DTP.Names[panelName] then
				panel.dataPanels[location]:HookScript("OnEnter", Button_OnEnter)
				panel.dataPanels[location]:HookScript("OnLeave", Button_OnLeave)
			end
			--Searching for gold
			for settingName, settingValue in T.pairs(DT.db.panels) do
				if settingValue and T.type(settingValue) == 'table' then --if options for panel exist and it is 2+ slot panel (2 cause DTBars exists)
					if settingName == panelName and DT.db.panels[settingName][location] and DT.db.panels[settingName][location] == "Gold" then
						--if it is current panel and options for it exist and it is gold dt, put the location in da cache
						DTP.GoldCache[panelName] = panel.dataPanels[location]
					elseif settingName == panelName and DT.db.panels[settingName][location] and DT.db.panels[settingName][location] == "S&L Currency" then
						--if it is current panel and options for it exist and it is s&l currency dt, set the flag to true
						IsCurrencyDTSelected = true
					end
				elseif settingValue and T.type(settingValue) == 'string' and settingValue == "Gold" then --if options for panel exist and it is 1 slot panel with gold dt
					if DT.db.panels[settingName] == "Gold" and settingName == panelName then
						DTP.GoldCache[panelName] = panel.dataPanels[location]
					end
				elseif settingValue and T.type(settingValue) == 'string' and settingValue == "S&L Currency" then --if options for panel exist and it is 1 slot panel with s&l currency
					if DT.db.panels[settingName] == "Gold" and settingName == panelName then
						IsCurrencyDTSelected = true
					end
				end
			end
		end
		--This should help with icons not following data panels
		if DTP.Names[panelName] then  E:Delay(0.1, function() Bar_OnLeave(panel, true) end) end
	end
	--Throttle for the amount of times this message is called. This func is called for every single change in DT options, so having it flood the chat is bad
	if OnLoadThrottle then
		OnLoadThrottle = false
		if IsCurrencyDTSelected then
			for panelName, datatext in T.pairs(DTP.GoldCache) do
				--Message about this particular panel having gold dt
				local message = T.format(L["SLE_DT_CURRENCY_WARNING_GOLD"], "|cff1784d1"..L[panelName].."|r")
				SLE:Print(message, "warning")
				--Unregister all events for this gold dt to prevent weird shit on currency
				if datatext then datatext:UnregisterAllEvents() end
			end
		end
		--1 second reset time should be enough to suppress all excessive automatic calls
		E:Delay(1, function() OnLoadThrottle = true end)
	end
end

--S&L's panel hook scripts for show/hide on mouseover. Currently unused
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

function DTP:CreatePanel(id)
	local panel = CreateFrame('Frame', "SLE_DataPanel_"..id, E.UIParent)
	panel.Num = id
	panel:SetFrameStrata('LOW')
	panel:Point(DTP.template[id].point, E.UIParent, DTP.template[id].point, DTP.template[id].x, 0);
	DT:RegisterPanel(panel, DTP.template[id].numSlots, 'ANCHOR_BOTTOM', 0, -4)
	panel:SetScript("OnEnter", Bar_OnEnter)
	panel:SetScript("OnLeave", Bar_OnLeave)
	panel:Hide()
	DTP.Names["SLE_DataPanel_"..id] = true

	return panel
end

function DTP:Mouseover(id)
	if DTP.db["panel"..id].mouseover then
		self["Panel_"..id]:SetAlpha(0)
		SubDTAlpha(self["Panel_"..id], 0)
	else
		self["Panel_"..id]:SetAlpha(DTP.db["panel"..id].alpha)
		SubDTAlpha(self["Panel_"..id], DTP.db["panel"..id].alpha)
	end
end

function DTP:Size(id)
	self["Panel_"..id]:Size(DTP.db["panel"..id].width, 20)
	DT.UpdatePanelDimensions(self["Panel_"..id])
end

function DTP:Toggle(id)
	if DTP.db["panel"..id].enabled then
		self["Panel_"..id]:Show()
		if DTP.db["panel"..id].mouseover then Bar_OnLeave(self["Panel_"..id]) end
		E:EnableMover(self["Panel_"..id].mover:GetName())
	else
		self["Panel_"..id]:Hide()
		E:DisableMover(self["Panel_"..id].mover:GetName())
	end
end

function DTP:PetHide(id)
	if DTP.db["panel"..id].pethide then
		E:RegisterPetBattleHideFrames(self["Panel_"..id], E.UIParent, "LOW")
	else
		E:UnregisterPetBattleHideFrames(self["Panel_"..id])
	end
end

function DTP:Template(id)
	if DTP.db["panel"..id].transparent then
		self["Panel_"..id]:SetTemplate(DTP.db["panel"..id].noback and "NoBackdrop" or "Transparent")
	else
		self["Panel_"..id]:SetTemplate(DTP.db["panel"..id].noback and "NoBackdrop" or "Default", true)
	end
end

function DTP:Alpha(id)
	self["Panel_"..id]:SetAlpha(DTP.db["panel"..id].alpha)
end

--Resizing chat panels if datapanels handling was enabled. Also applies alpha setting to those, since I can't pass id on those
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
	for id = 1, 8 do
		if not self["Panel_"..id] then self["Panel_"..id] = DTP:CreatePanel(id) end
		DTP:Size(id)
		DTP:Template(id)
		if not E.CreatedMovers["SLE_DataPanel_"..id.."_Mover"] then E:CreateMover(self["Panel_"..id], "SLE_DataPanel_"..id.."_Mover", L["SLE_DataPanel_"..id], nil, nil, nil, "ALL,S&L,S&L DT") end
		DTP:Toggle(id)
		DTP:PetHide(id)
		DTP:Alpha(id)
		DTP:Mouseover(id)
	end
	DTP:ChatResize()
end

--This deletes gold data for selected character. Called from config.
function DTP:DeleteCurrencyEntry(data)
	if ElvDB['gold'][data.realm] and ElvDB['gold'][data.realm][data.name] then
		ElvDB['gold'][data.realm][data.name] = nil;
	end
	if ElvDB['class'] and ElvDB['class'][data.realm] then
		if ElvDB['class'][data.realm][data.name] then
			ElvDB['class'][data.realm][data.name] = nil;
		end
	end
	if ElvDB['faction'] and ElvDB['faction'][data.realm] then
		if ElvDB['faction'][data.realm]["Alliance"][data.name] then
			ElvDB['faction'][data.realm]["Alliance"][data.name] = nil;
		end
		if ElvDB['faction'][data.realm]["Horde"][data.name] then
			ElvDB['faction'][data.realm]["Horde"][data.name] = nil;
		end
	end
	E.Libs["AceConfigDialog"]:ConfigTableChanged(nil, "ElvUI")
end

function DTP:Initialize()
	if not SLE.initialized then return end

	function DTP:ForUpdateAll()
		DTP.db = E.db.sle.datatexts
		DTP:CreateAndUpdatePanels()
	end

	DTP:ForUpdateAll()

	--Hooking to default DTs for additional features
	DTP:HookTimeDT()
	DTP:HookDurabilityDT()

	--Creating specifing DTs
	DTP:CreateMailDT()
	DTP:CreateCurrencyDT()
	--Replacing OnClick function for SpecSwitch DT
	DTP:ReplaceSpecSwitch()

	--Finishing setup for delete character gold data popup
	local popup = E.PopupDialogs['SLE_CONFIRM_DELETE_CURRENCY_CHARACTER']
	popup.OnAccept = DTP.DeleteCurrencyEntry

	--Hooking to default functions to remove gold conflicts
	-- hooksecurefunc(DT, "LoadDataTexts", DTP.MouseoverHook)
	hooksecurefunc(DT, "LoadDataTexts", DTP.LoadDTHook)
	hooksecurefunc(MM, "UpdateSettings", DTP.LoadDTHook)
	DTP:LoadDTHook()
end

SLE:RegisterModule(DTP:GetName())