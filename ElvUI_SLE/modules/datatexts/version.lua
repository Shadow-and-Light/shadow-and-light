--Version datatext. Only in Russian for now.
local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')
local SLE = E:GetModule('SLE')
local ACD = LibStub("AceConfigDialog-3.0")

local displayString = '';
local lastPanel;
local self = lastPanel
local join = string.join
E.version = GetAddOnMetadata("ElvUI", "Version");

local function OnEvent(self, event, ...)
	self.text:SetFormattedText(displayString, 'ElvUI v', E.version, SLE.version);
end

local function Click()
	ElvConfigToggle:Click();
	ACD:SelectGroup("ElvUI", "sle")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:AddDoubleLine("ElvUI "..L["Version"]..format(": |cff99ff33%s|r",E.version))
	DT.tooltip:AddLine(L["SLE_AUTHOR_INFO"]..". "..L["Version"]..format(": |cff99ff33%s|r",SLE.version))
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

DT:RegisterDatatext("Version", {'PLAYER_ENTERING_WORLD'}, OnEvent, Update, Click, OnEnter)

