--Version datatext. Only in Russian for now.
local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')
local SLE = E:GetModule('SLE')
local ACD = LibStub("AceConfigDialog-3.0")

local displayString = '';
local lastPanel;
local self = lastPanel
local join = string.join
local AddLine = AddLine
local AddDoubleLine =AddDoubleLine
local Eversion = E.version
local format = format

local function OnEvent(self, event, ...)
	self.text:SetFormattedText(displayString, 'ElvUI v', Eversion, SLE.version);
end

local function Click()
	ElvConfigToggle:Click();
	ACD:SelectGroup("ElvUI", "sle")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:AddDoubleLine("ElvUI "..GAME_VERSION_LABEL..format(": |cff99ff33%s|r", Eversion))
	DT.tooltip:AddLine(L["SLE_AUTHOR_INFO"]..". "..GAME_VERSION_LABEL..format(": |cff99ff33%s|r", SLE.version))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L['SLE_CONTACTS'])
	
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", "%s", hex, "%.2f|r", " : Shadow & Light Edit v", hex, "%.2f|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext("S&L "..GAME_VERSION_LABEL, {'PLAYER_ENTERING_WORLD'}, OnEvent, Update, Click, OnEnter)

